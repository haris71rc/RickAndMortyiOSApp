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
    
    enum rmServiceError: Error{
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Rick ANd Morty API call
    /// - Parameters:
    ///   - request: Request instance
    ///   - completion: callback with data or error
    ///   - type: Type of object we expect to get back
    public func execute<T: Codable>(_ request: RMRequest,expecting type: T.Type, completion: @escaping(Result<T,Error>)->Void){
        guard let urlRequest = self.request(from: request) else{
            completion(.failure(rmServiceError.failedToCreateRequest))
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data , error == nil else {
                completion(.failure(error ?? rmServiceError.failedToGetData))
                return}
            do{
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            }
            catch{
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    //MARK: - PRIVATE
    
    private func request(from rmRequest: RMRequest)->URLRequest?{
        guard let url = rmRequest.url else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        
        return request
    }
}
