//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 01/07/24.
//

import Foundation

final class RMCharacterCollectionViewCellViewModel: Hashable, Equatable{
    
    
    public let characterName: String
    private let characterStatus: RMCharacterStatus
    private let characterImageURL : URL?
    
    
    
    //MARK: - Init
    init(characterName:String, characterStatus:RMCharacterStatus, characterImageURL:URL?){
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageURL = characterImageURL
    }
    
    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
    }
    
    public func fetchImage(completion: @escaping (Result<Data,Error>) ->Void){
        guard let url = characterImageURL else{
            completion(.failure(URLError(.badURL)))
            return}
        
        RMImageLoader.shared.downloadImage(url, completion: completion)
    }
    
    //MARK: - Hashing
    static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageURL)
    }
}
