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
     let endPoint: RMEndpoint
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
    
    /// Attempt to create request
    /// - Parameter url: url to parse
    convenience init?(url:URL){
        let string = url.absoluteString
        if !string.contains(Constants.baseURL){
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseURL + "/", with: "")
        if trimmed.contains("/"){
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty{
                let endpointString = components[0] //Endpoint
                var pathComponents: [String] = []
                if components.count > 1{
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let rmEndpoint = RMEndpoint(rawValue: endpointString){
                    self.init(endPoint: rmEndpoint,pathComponents: pathComponents)
                    return
                }
            }
        }
        else if trimmed.contains("?"){
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty,components.count>=2{
                let endpointString = components[0]
                let queryItemString = components[1]
                let queryItems: [URLQueryItem] = queryItemString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else{
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(name: parts[0], value: parts[1])
                })
                if let rmEndpoint = RMEndpoint(rawValue: endpointString){
                    self.init(endPoint: rmEndpoint,queryParameters: queryItems)
                    return
                }
            }
        }
        return nil
    }
}

extension RMRequest{
    static let listCharacters = RMRequest(endPoint: .character)
    static let listEpisodes = RMRequest(endPoint: .episode)
}
