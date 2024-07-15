//
//  RMAPICacheManager.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 11/07/24.
//

import Foundation

final class RMAPICacheManager{
    
    /// Through this i am making a separate cache for each endpoints
    private var cacheDictionary: [RMEndpoint: NSCache<NSString, NSData>] = [:]
    
    init(){
        setUpCache()
    }
    
    //MARK: - Public
    
    
    /// Getting data from the cache
    /// - Parameters:
    ///   - endPoint: endpoint(character,episode,location) specifies particular cache we r referring
    ///   - url: url for that particular endpoint
    /// - Returns: data stored in the cache
    public func cacheResponse(for endPoint: RMEndpoint,url:URL?)->Data?{
        guard let targetCache = cacheDictionary[endPoint],let url = url else{
            return nil
        }
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    public func setCache(for endPoint: RMEndpoint,url:URL?,data: Data){
        guard let targetCache = cacheDictionary[endPoint],let url = url else{
            return
        }
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }
    
    //MARK: - Private
    private func setUpCache(){
        RMEndpoint.allCases.forEach { endPoints in
            cacheDictionary[endPoints] = NSCache<NSString,NSData>()   // instantiationing separate cache object for each endpoint
        }
    }
}
