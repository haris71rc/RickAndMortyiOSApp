//
//  RMSearchInputViewViewModel.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 21/07/24.
//

import Foundation

final class RMSearchInputViewViewModel{
    
    private let type: RMSearchViewController.Config.`Type`
    
    enum dynamicOption: String{
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"
    }
    
    /*case character // name | status | gender
     case episode  // name
     case location// name | type*/
    
    //MARK: - Init
    init(type: RMSearchViewController.Config.`Type`){
        self.type = type
    }
    
    //MARK: - Public
    public var hasDynamicOptions: Bool{
        switch type {
        case .character:
            return true
        case .episode:
            return false
        case .location:
            return true
        }
    }
    
    public var options: [dynamicOption] {
        switch type {
        case .character:
            return [.status,.gender]
        case .episode:
            return []
        case .location:
            return [.locationType]
        }
    }
    public var searchPlaceholderText: String{
        switch type {
        case .character:
            return "Character Name"
        case .episode:
            return "Episode Title"
        case .location:
            return "Location Name"
        }
    }
}
