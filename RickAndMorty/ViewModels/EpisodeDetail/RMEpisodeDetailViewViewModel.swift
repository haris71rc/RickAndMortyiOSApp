//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 11/07/24.
//

import UIKit

protocol RMEpisodeDetailViewViewModelDelegate:AnyObject {
    func didFetchEpisodeDetails()
}

class RMEpisodeDetailViewViewModel {
    
    private let endpointURL: URL?
    private var dataTuple: (episode:RMEpisode, characters: [RMCharacter])?{
        didSet{
            createCellViewModel()
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    enum sectionType{
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case character(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    public weak var delegate:RMEpisodeDetailViewViewModelDelegate?
    
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
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        var createdString = ""
        guard let createdDate = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created) else{
            return
        }
        createdString = RMCharacterInfoCollectionViewCellViewModel.shortFormatter.string(from: createdDate)
        cellViewModels = [
            .information(viewModels: [
                .init(title:"Episode Name " , value: episode.name),
                .init(title:"Air Date " , value: episode.air_date),
                .init(title:"Episode " , value: episode.episode),
                .init(title:"Created " , value: createdString)
            ]),
            .character(viewModel: characters.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(characterName: character.name,
                                                              characterStatus: character.status,
                                                              characterImageURL: URL(string: character.image))
            }))
        ]
    }
    public func fetchEpisodeData(){
        guard let url = endpointURL, let request = RMRequest(url: url) else{
            return
        }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result{
            case .success(let model):
                self?.fetchRelatedCharacters(episode: model)
            case .failure:
                break
            }
        }
    }
    
    private func fetchRelatedCharacters(episode: RMEpisode){
        let characterUrls:[URL] = episode.characters.compactMap({
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
                episode,characters
            )
        }
    }
}
