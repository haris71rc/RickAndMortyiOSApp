//
//  RMService.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 26/04/24.
//

import Foundation

/// Primary API service object to get rick and morty API
final class RMService{
    /// Shared singleton instance
    static let shared = RMService()
    
    ///privatized constructor
    private init() {}
    
    /// Rick ANd Morty API call
    /// - Parameters:
    ///   - request: Request instance
    ///   - completion: callback with data or error
    public func execute(_ request: RMRequest, completion: @escaping()->Void){
        
    }
}
