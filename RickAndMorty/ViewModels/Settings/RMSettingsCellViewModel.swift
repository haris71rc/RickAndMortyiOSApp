//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 16/07/24.
//

import UIKit

struct RMSettingsCellViewModel:Identifiable{
    let id = UUID() // creates a unique ID for each of the instances of the view model we create
    
    public let type: RMSettingsOption
    public let onTapHandler: (RMSettingsOption)->Void
    
    //MARK: - Init
    init(type: RMSettingsOption, onTapHandler: @escaping(RMSettingsOption)->Void){
        self.type = type
        self.onTapHandler = onTapHandler
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
