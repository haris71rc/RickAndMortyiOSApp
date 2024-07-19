//
//  RMLocationDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 20/07/24.
//

import Foundation


protocol RMLocationDetailViewViewModelDelegate:AnyObject {
    func didFetchLocationDetails()
}

class RMLocationDetailViewViewModel {
    
    private let endpointURL: URL?
    private var dataTuple: (location:RMLocation, characters: [RMCharacter])?{
        didSet{
            createCellViewModel()
            delegate?.didFetchLocationDetails()
        }
    }
    
    enum sectionType{
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case character(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    public weak var delegate:RMLocationDetailViewViewModelDelegate?
    
    public private(set) var cellViewModels: [sectionType] = []

    //MARK: - Init
    init(endpointURL: URL?){
        self.endpointURL = endpointURL
    }
    
    public func character(at Index: Int) ->RMCharacter?{
        guard let dataTuple = dataTuple else{
            return nil
        }
        return dataTuple.characters[Index]
    }
    
    private func createCellViewModel(){
        guard let dataTuple = dataTuple else{
            return
        }
        let location = dataTuple.location
        let characters = dataTuple.characters
        var createdString = ""
        guard let createdDate = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created) else{
            return
        }
        createdString = RMCharacterInfoCollectionViewCellViewModel.shortFormatter.string(from: createdDate)
        cellViewModels = [
            .information(viewModels: [
                .init(title:"Location Name " , value: location.name),
                .init(title:"Type " , value: location.type),
                .init(title:"Dimension " , value: location.dimension),
                .init(title:"Created " , value: createdString)
            ]),
            .character(viewModel: characters.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(characterName: character.name,
                                                              characterStatus: character.status,
                                                              characterImageURL: URL(string: character.image))
            }))
        ]
    }
    public func fetchLocationData(){
        guard let url = endpointURL, let request = RMRequest(url: url) else{
            return
        }
        
        RMService.shared.execute(request, expecting: RMLocation.self) { [weak self] result in
            switch result{
            case .success(let model):
                self?.fetchRelatedCharacters(location: model)
            case .failure:
                break
            }
        }
    }
    
    private func fetchRelatedCharacters(location: RMLocation){
        let characterUrls:[URL] = location.residents.compactMap({
            return URL(string: $0)
        })
        let requests:[RMRequest] = characterUrls.compactMap({
            return RMRequest(url: $0)
        })
        
        let group = DispatchGroup() //by making DispatchGroup we r parallely executing all the calls for the characters
        var characters: [RMCharacter] = []
        for request in requests{
            group.enter() // when we make call for each request it get incremented by +1
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                defer{
                    group.leave()  //it,s the last block thats get executed after every call it decrements by -1
                }
                
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        group.notify(queue: .main){
            self.dataTuple = (
                location,characters
            )
        }
    }
}
