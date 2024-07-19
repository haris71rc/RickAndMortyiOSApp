//
//  RMLocationTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 17/07/24.
//

import Foundation

struct RMLocationTableViewCellViewModel: Equatable,Hashable{
    
    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(location.id)
        hasher.combine(type)
        hasher.combine(dimension)
    }
    
    private let location: RMLocation
    init(location: RMLocation){
        self.location = location
    }
    
    public var name:String{
        return location.name
    }
    public var type:String{
        return "Type: "+location.type
    }
    public var dimension:String{
        return location.dimension
    }
}
