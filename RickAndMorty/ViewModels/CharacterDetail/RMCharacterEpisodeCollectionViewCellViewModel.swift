//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 09/07/24.
//

import UIKit

protocol RMEpisodeDataRender{
    var name: String { get }
    var air_date: String { get }
    var episode: String { get }
}

final class RMCharacterEpisodeCollectionViewCellViewModel:Hashable,Equatable{
    
    public let borderColor: UIColor
    private let episodeDataURL: URL?
    private var isFetching = false
    private var dataBlock: ((RMEpisodeDataRender)->Void)?
    private var episodes: RMEpisode?{
        didSet{ //disSet is called as soon as something is assigned to episode variable
            guard let model = episodes else{
                return
            }
            dataBlock?(model)
        }
    }
    
    //MARK: - Init
    init(episodeDataURL: URL?,borderColor: UIColor = .systemBlue){
        self.episodeDataURL=episodeDataURL
        self.borderColor = borderColor
    }
    
    //MARK: - Public
    public func registerForData(_ block: @escaping(RMEpisodeDataRender)->Void){
        self.dataBlock = block
    }
    
    public func fetchEpisode(){
        guard !isFetching else{
            if let model = episodes{
                dataBlock?(model)
            }
            return
        }
        guard let url = episodeDataURL , let request = RMRequest(url: url) else{
            return
        }
        isFetching = true
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async{
                    self?.episodes = model
                }
            case .failure(let failure):
                print(String(describing:"Failed to get episodes details in character detail view \(failure)"))
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataURL?.absoluteString ?? "")
    }
    static func == (lhs: RMCharacterEpisodeCollectionViewCellViewModel, rhs: RMCharacterEpisodeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
