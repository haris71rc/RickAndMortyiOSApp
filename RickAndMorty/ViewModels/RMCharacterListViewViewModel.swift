//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 01/05/24.
//

import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject{
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    func didSelectCharacter(_ character: RMCharacter)
}

/// View model to handle character list logic
final class RMCharacterListViewViewModel: NSObject{
    
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    private var isdLoadingMoreCharacters = false
    
    private var characters: [RMCharacter] = [] {
        didSet{
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(characterName: character.name,
                                                                       characterStatus: character.status,
                                                                       characterImageURL: URL(string: character.image)
                )
                if !cellViewModels.contains(viewModel){
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    
    private var apiInfo: RMGetAllCharactersResponse.Info? = nil
    /// Fetch initial set of characters(20)
   public func fetchCharacters(){
        RMService.shared.execute(.listCharacters, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            switch result{
            case .success(let responseModel):
                let result = responseModel.results
                let info = responseModel.info
                self?.characters = result
                self?.apiInfo = info
                DispatchQueue.main.async{
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
   }
    /// Paginate if additional characters is needed
    public func fetchAdditionalCharacters(url: URL){
        guard !isdLoadingMoreCharacters else{
            return
        }
        isdLoadingMoreCharacters=true

        guard let request = RMRequest(url: url) else{
            isdLoadingMoreCharacters=false
            return}
        
        RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            guard let strongSelf=self else{return}
            switch result{
            case .success(let responseModel):
                let moreResult = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
                
                let originalCount = strongSelf.characters.count
                let newCount = moreResult.count
                let total = originalCount+newCount
                let startingIndex = total-newCount
                let rangi = startingIndex..<(startingIndex+newCount)
                let indexPathToAdd : [IndexPath] = Array(rangi).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                
                strongSelf.characters.append(contentsOf: moreResult)
                DispatchQueue.main.async{
                    strongSelf.delegate?.didLoadMoreCharacters(with: indexPathToAdd)
                    strongSelf.isdLoadingMoreCharacters = false
                }
            case .failure(let error):
                print("Error to fetch additional characters \(error)")
                strongSelf.isdLoadingMoreCharacters = false
            }
        }
    }
    public var shouldShowLoadMoreIndicator: Bool{
        return apiInfo?.next != nil
    }
}

//MARK: - CollectionView
extension RMCharacterListViewViewModel: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath)
                as? RMCharacterCollectionViewCell else{
           fatalError("Unsupported cell")
       }
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else{
            fatalError("Unsupported")
        }
        
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                                                                     for: indexPath) as? RMFooterLoadingCollectionReusableView
                 else{fatalError("Unsupported")}
        footer.startAnimating()
        return footer
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else{
            return .zero
        }
        return CGSize(width: collectionView.frame.width , height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isIphone = UIDevice.current.userInterfaceIdiom == .phone
        let bounds = collectionView.bounds
        let width : CGFloat
        if isIphone{
            width = (bounds.width-30)/2
        }
        else{
            //Mac | Ipad
            width = (bounds.width-50)/4
        }
        
        return CGSize(
            width: width,
            height: width*1.5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}

//MARK: - ScrollView
extension RMCharacterListViewViewModel: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator, !isdLoadingMoreCharacters,!cellViewModels.isEmpty,
              let urlString=apiInfo?.next,
              let url=URL(string: urlString) else{
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
                let offset = scrollView.contentOffset.y
                let totalContentHeight = scrollView.contentSize.height
                let totalScrollViewFixedHeight = scrollView.frame.size.height
                
                if(offset >= (totalContentHeight-totalScrollViewFixedHeight-120)){
                    self?.fetchAdditionalCharacters(url: url)
                }
                t.invalidate()
        }
       
    }
}
