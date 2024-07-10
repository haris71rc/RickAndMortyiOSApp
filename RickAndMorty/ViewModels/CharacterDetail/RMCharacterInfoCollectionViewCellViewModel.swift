//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 09/07/24.
//

import UIKit

final class RMCharacterInfoCollectionViewCellViewModel{
    private let value:String
    private let type:`Type`
    
    static let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = .current
        return formatter
    }()
    
    static let shortFormatter: DateFormatter = {
        let outputFormat = DateFormatter()
        outputFormat.dateFormat = "yyyy-MM-dd"
        outputFormat.locale = .current
        outputFormat.dateStyle = .medium
        outputFormat.timeStyle = .short
        return outputFormat
    }()
    
    public var title:String{
         type.displayTitle
    }
    
    public var displayValue:String{
        if value.isEmpty{
            return "None"
        }
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: value), type == .created{
            return RMCharacterInfoCollectionViewCellViewModel.shortFormatter.string(from: date)
        }
        return value
    }
    
    public var iconImage: UIImage?{
        return type.iconImage
    }
    
    public var tintColor:UIColor{
        return type.tintColor
    }
    
    enum `Type`{
        case status
        case species
        case type
        case gender
        case origin
        case location
        case created
        case episodeCount
        
        var tintColor:UIColor{
            switch self{
            case .status:
                return .systemRed
            case .species:
                return .systemBlue
            case .type:
                return .systemCyan
            case .gender:
                return .systemGray
            case .origin:
                return .systemMint
            case .location:
                return .systemPink
            case .created:
                return .systemTeal
            case .episodeCount:
                return .systemBrown
            }
        }
        
        var iconImage:UIImage?{
            switch self{
            case .status:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .episodeCount:
                return UIImage(systemName: "bell")
            }
        }
        
        var displayTitle:String{
            switch self{
                /*
                 or we can write it as:-
                 case .status,.species,.type,.etc
                 return rawvalue.upperCased()
                 */
            case .status:
                return "Status"
            case .species:
                return "Species"
            case .type:
                return "Type"
            case .gender:
                return "Gender"
            case .origin:
                return "Origin"
            case .location:
                return "Location"
            case .created:
                return "Created"
            case .episodeCount:
                return "Episode Count"
            }
        }
        
        
    }
    init(type: `Type`,value:String){
        self.type=type
        self.value=value
    }
}
