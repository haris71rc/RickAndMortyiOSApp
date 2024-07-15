//
//  RMEpisodeListViewViewModel.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 11/07/24.
//

import UIKit

protocol RMEpisodeListViewViewModelDelegate: AnyObject{
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
    func didSelectEpisode(_ episode: RMEpisode)
}

/// View model to handle Episode list logic
final class RMEpisodeListViewViewModel: NSObject{
    
    public weak var delegate: RMEpisodeListViewViewModelDelegate?
    
    private var isdLoadingMoreEpisodes = false
    
    private var borderColor:[UIColor] = [
        .systemRed,.systemBlue,.systemGreen,.systemOrange,.systemYellow,.systemPink,.systemTeal,.systemCyan,.systemGray,.systemMint,.systemBrown
    ]
    
    private var episodes: [RMEpisode] = [] {
        didSet{
            for episode in episodes {
                let viewModel = RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataURL: URL(string: episode.url),borderColor: borderColor.randomElement() ?? .systemBlue)
                if !cellViewModels.contains(viewModel){
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [RMCharacterEpisodeCollectionViewCellViewModel] = []
    
    private var apiInfo: RMGetAllEpisodesResponse.Info? = nil
    /// Fetch initial set of Episodes(20)
   public func fetchEpisodes(){
       RMService.shared.execute(.listEpisodes, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
            switch result{
            case .success(let responseModel):
                let result = responseModel.results
                let info = responseModel.info
                self?.episodes = result
                self?.apiInfo = info
                DispatchQueue.main.async{
                    self?.delegate?.didLoadInitialEpisodes()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
   }
    /// Paginate if additional episodes is needed
    public func fetchAdditionalEpisodes(url: URL){
        guard !isdLoadingMoreEpisodes else{
            return
        }
        isdLoadingMoreEpisodes=true

        guard let request = RMRequest(url: url) else{
            isdLoadingMoreEpisodes=false
            return}
        
        RMService.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
            guard let strongSelf=self else{return}
            switch result{
            case .success(let responseModel):
                let moreResult = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
                
                let originalCount = strongSelf.episodes.count
                let newCount = moreResult.count
                let total = originalCount+newCount
                let startingIndex = total-newCount
                let rangi = startingIndex..<(startingIndex+newCount)
                let indexPathToAdd : [IndexPath] = Array(rangi).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                
                strongSelf.episodes.append(contentsOf: moreResult)
                DispatchQueue.main.async{
                    strongSelf.delegate?.didLoadMoreEpisodes(with: indexPathToAdd)
                    strongSelf.isdLoadingMoreEpisodes = false
                }
            case .failure(let error):
                print("Error to fetch additional characters \(error)")
                strongSelf.isdLoadingMoreEpisodes = false
            }
        }
    }
    public var shouldShowLoadMoreIndicator: Bool{
        return apiInfo?.next != nil
    }
}

//MARK: - CollectionView
extension RMEpisodeListViewViewModel: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier, for: indexPath)
                as? RMCharacterEpisodeCollectionViewCell else{
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
        let bounds = collectionView.bounds
        let width = (bounds.width-20)
        
        return CGSize(
            width: width,
            height: 100
        )
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selection = episodes[indexPath.row]
        delegate?.didSelectEpisode(selection)
    }
}

//MARK: - ScrollView
extension RMEpisodeListViewViewModel: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator, !isdLoadingMoreEpisodes,!cellViewModels.isEmpty,
              let urlString=apiInfo?.next,
              let url=URL(string: urlString) else{
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
                let offset = scrollView.contentOffset.y
                let totalContentHeight = scrollView.contentSize.height
                let totalScrollViewFixedHeight = scrollView.frame.size.height
                
                if(offset >= (totalContentHeight-totalScrollViewFixedHeight-120)){
                    self?.fetchAdditionalEpisodes(url: url)
                }
                t.invalidate()
        }
       
    }
}
