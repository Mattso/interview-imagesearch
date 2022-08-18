//
//  PixabayImageSearchProvider.swift
//  PixabaySearchDemo
//
//  Created by Matthew Magee on 18/08/2022.
//

import Foundation

class PixabayImageSearchProvider: NetworkService, ImageSearchAPIContract {
    
    var cacheProvider: ResponseCachingContract
    
    private var API_ACCESS_KEY: String = "29361076-55168dd1b766c0e68d7ce2be1"

    init(cacheProvider: ResponseCachingContract) {
        self.cacheProvider = cacheProvider
    }
    
    func searchFor(query: String, type: String) async -> Result<[GenericImage], ImageSearchAPIError> {
        
        if let validQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            if let cachedResponse = cacheProvider.fetchResponse(forQuery: validQuery) {
                print("Returning cached response for search: \(validQuery)")
                return .success(cachedResponse)
            } else {
                print("Using API for search: \(validQuery)")
            }
            
            let apiPath = "https://pixabay.com/api/?key=\(API_ACCESS_KEY)&q=\(validQuery)&image_type=\(type)".replacingOccurrences(of: "\u{200B}", with: "")

            if let validURL = URL(string: apiPath) {
                
                var newRequest = URLRequest(url: validURL)
                newRequest.httpMethod = "GET"
                let pixabayResponse = await self.makeAsynchronousAPICall(with: newRequest, responseModel: PixabaySearchResponseModel.self)
                
                //parse out the response
                
                switch pixabayResponse {
                case .success(let response):
                    
                    //convert pixabay bespoke data into our local generic data
                    var genericImages: [GenericImage] = []
                    for hit in response.hits {
                        let convertedHit = GenericImage(thumbnailURL: hit.previewURL, thumbnailWidth: hit.previewWidth, thumbnailHeight: hit.previewHeight, fullImageURL: hit.largeImageURL, communityTags: hit.tags, communityViews: hit.views, communityDownloads: hit.downloads, communityComments: hit.comments, imageOwnerName: hit.user, imageOwnerAvatarURL: hit.userImageURL)
                        genericImages.append(convertedHit)
                    }
                    
                    //populate the cache
                    cacheProvider.store(response: genericImages, forQuery: validQuery)
                    
                    //return the data
                    return .success(genericImages)
                    
                case .failure(let error):
                    return .failure(error)
                }
                
            }  else {
                return .failure(.badlyFormedRequest)
            }
        } else {
            return .failure(.badlyFormedRequest)
        }
        
    } //searchFor
    
    func searchProviderLogo() -> String {
        return "pixabayLogo"
    }
    
    func searchProviderAttributionLink() -> URL {
        return URL(string: "https://pixabay.com")!
    }

    //
    //MODEL DATA
    //

    struct PixabaySearchResponseModel: Codable {
        var total: Int
        var totalHits: Int
        var hits: [PixabayImageHit]
    }

    struct PixabayImageHit: Codable {
        
        //overview
        var id: Int
        var pageURL: String
        var type: String
        var tags: String
        //image data
        var previewURL: String
        var previewWidth: Int
        var previewHeight: Int
        var webformatURL: String
        var webformatWidth: Int
        var webformatHeight: Int
        var largeImageURL: String
        var fullHDURL: String?
        var imageURL: String?
        var imageWidth: Int
        var imageHeight: Int
        var imageSize: Int
        //community stats
        var views: Int
        var downloads: Int
        var comments: Int
        //image originator
        var user_id: Int
        var user: String
        var userImageURL: String

        //TODO: fix decodable conformance
    //    enum CodingKeys: String, CodingKey {
    //        //NOTE: CodingKeys has to be exhaustive, even though there's only one mapping, because
    //        //      otherwise we'd need default values for all the unmapped cases.
    //        case id
    //        case pageURL
    //        case type
    //        case tags
    //        case previewURL
    //        case previewWidth
    //        case previewHeight
    //        case webformatURL
    //        case webformatWidth
    //        case webformatHeight
    //        case largeImageURL
    //        case fullHDURL
    //        case imageURL
    //        case imageWidth
    //        case imageHeight
    //        case imageSize
    //        case views
    //        case downloads
    //        case comments
    //        case userID = "user_id"
    //        case user
    //    }

    }


    
}
