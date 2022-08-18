//
//  GenericCacheProvider.swift
//  PixabaySearchDemo
//
//  Created by Matthew Magee on 18/08/2022.
//

import Foundation

class GenericCacheProvider: ResponseCachingContract {
    
    //TODO: make this actually generic, like the network responses - just hardcoded to GenericImage for speed and convenience
    
    private var responseCache =  [String:[GenericImage]]() //TODO: create a container with a timestamp and a TTL before the cached data is cleared

    func fetchResponse(forQuery query: String) -> [GenericImage]? {
        return responseCache[query]
    }
    
    func store(response: [GenericImage], forQuery query: String) {
        responseCache[query] = response
    }
    
}
