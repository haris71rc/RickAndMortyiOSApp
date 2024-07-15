//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 26/04/24.
//

import Foundation

/// Represent unique API endpoint
@frozen enum RMEndpoint: String,Hashable,CaseIterable{
    case character     //we have added this String data type because it will give us the raw value whenever we say RMEndpoint.character etc
    case location
    case episode
}
