//
//  RMSettingsOption.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 16/07/24.
//

import UIKit

enum RMSettingsOption: CaseIterable{
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    var displayTitle: String{
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .terms:
            return "Terms"
        case .privacy:
            return "Privacy"
        case .apiReference:
            return "API References"
        case .viewSeries:
            return "View Series"
        case .viewCode:
            return "View Code"
        }
    }
    
    var iconImage: UIImage?{
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
    
    var itemContainerColor: UIColor{
        switch self {
        case .rateApp:
            return .systemRed
        case .contactUs:
            return .systemYellow
        case .terms:
            return .systemPink
        case .privacy:
            return .systemPurple
        case .apiReference:
            return .systemOrange
        case .viewSeries:
            return .systemMint
        case .viewCode:
            return .systemTeal
        }
    }
}
