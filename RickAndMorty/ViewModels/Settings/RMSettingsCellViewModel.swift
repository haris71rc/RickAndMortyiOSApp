//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 16/07/24.
//

import UIKit

struct RMSettingsCellViewModel:Identifiable,Hashable{
    let id = UUID() // creates a unique ID for each of the instances of the view model we create
    
    private let type: RMSettingsOption
    
    //MARK: - Init
    init(type: RMSettingsOption){
        self.type = type
    }
    
    //MARK: - Public
    public var image: UIImage?{
        return type.iconImage
    }
    public var title: String{
        return type.displayTitle
    }
    public var iconContainerColor :UIColor{
        return type.itemContainerColor
    }
}
