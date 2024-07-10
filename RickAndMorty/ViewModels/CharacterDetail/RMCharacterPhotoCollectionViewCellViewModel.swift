//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 09/07/24.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel{
    private let imageURL: URL?
    init(imageURL: URL?){
        self.imageURL=imageURL
    }
    
    public func fetchImage(completion: @escaping(Result<Data,Error>)->Void){
        guard let url = imageURL else{
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.downloadImage(url, completion: completion)
    }
}
