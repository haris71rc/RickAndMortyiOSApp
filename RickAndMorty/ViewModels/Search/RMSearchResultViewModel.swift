//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 24/07/24.
//

import Foundation



enum RMSearchResultViewModel{
   case characters([RMCharacterCollectionViewCellViewModel])
   case locations([RMLocationTableViewCellViewModel])
   case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
}
