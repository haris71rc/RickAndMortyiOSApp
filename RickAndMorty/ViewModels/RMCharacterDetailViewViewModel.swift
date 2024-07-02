//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 01/07/24.
//

import Foundation

class RMCharacterDetailViewViewModel{
    private let character:RMCharacter
    
    init(character: RMCharacter){
        self.character = character
    }
    
    public var title: String{
        character.name.uppercased()
    }
}
