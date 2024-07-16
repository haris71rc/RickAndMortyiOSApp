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
    
    var targetURL: URL?{
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https://github.com/haris71rc/RickAndMortyiOSApp")
        case .terms:
            return URL(string: "https://github.com/haris71rc/RickAndMortyiOSApp")
        case .privacy:
            return URL(string: "https://github.com/haris71rc/RickAndMortyiOSApp")
        case .apiReference:
            return URL(string: "https://rickandmortyapi.com/documentation/#get-multiple-characters")
        case .viewSeries:
            return URL(string: "https://www.youtube.com/watch?v=EZpZDuOAFKE&list=PL5PR3UyfTWvdl4Ya_2veOB6TM16FXuv4y&index=1")
        case .viewCode:
            return URL(string: "https://github.com/haris71rc/RickAndMortyiOSApp")
        }
    }
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
