//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 26/04/24.
//

import Foundation

/// object that represent a single api call
final class RMRequest{
    //Base URL
    //Endpoints
    //Path Components
    //Query Parameters
    
    /// API constants
    private struct Constants {
        static let baseURL = "https://rickandmortyapi.com/api"
    }
    
    /// Desired Endpoints
    private let endPoint: RMEndpoint
    /// Path Components for API, if any
    private let pathComponents: [String]
    /// query parameters for API, if any
    private let queryParameters: [URLQueryItem]
    
    /// Constructed url for API request in string format
    private var urlString: String{
        var string = Constants.baseURL
        string += "/"
        string += endPoint.rawValue
        
        if !pathComponents.isEmpty{
            pathComponents.forEach { value in
                string += "/\(value)"
            }
        }
        if !queryParameters.isEmpty{
            //queryParameters ke liye URL aise form hogi => name=value&name=value
           string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else {return nil}
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentString
        }
        
        return string
    }
    
    /// Computed & Constructed API url
    public var url : URL? {
        return URL(string: urlString)
    }
    
    /// Desired HTTP method
    public let httpMethod = "GET"
    
    //MARK: - PUBLIC
    
    /// Construct Request
    /// - Parameters:
    ///   - endPoint: Target Endpoint
    ///   - pathComponents: Collection of path components
    ///   - queryParameters: Collection of query parameters
   public init(endPoint: RMEndpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endPoint = endPoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
}

extension RMRequest{
    static let listCharacters = RMRequest(endPoint: .character)
}
