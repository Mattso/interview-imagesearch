//
//  NetworkService.swift
//  PixabaySearchDemo
//
//  Created by Matthew Magee on 18/08/2022.
//

import Foundation

protocol ImageSearchAPIContract {
    func searchFor(query: String, type: String) async -> Result<[GenericImage], ImageSearchAPIError>
    func searchProviderLogo() -> String
    func searchProviderAttributionLink() -> URL
}

protocol ResponseCachingContract {
    func fetchResponse(forQuery query: String) -> [GenericImage]?
    func store(response: [GenericImage], forQuery query: String)
}

enum ImageSearchAPIError: Error {
    case unknown
    case unexpectedResponseCode(Int)
    case unauthorised
    case apiKeyRejected
    case noResponse
    case parsingFailed
    case missingResponseData
    case failedWithMessage(String)
    case badlyFormedRequest
}

class NetworkService {

    //convenience generic data request
    
    func makeAsynchronousAPICall<T: Decodable>(with request: URLRequest, authenticated: Bool = true, contentType: String = "application/json", responseModel: T.Type) async ->  Result<T, ImageSearchAPIError> {
        
        var localReq = request
        
        //add generic headers
        
        localReq.setValue(contentType, forHTTPHeaderField: "Content-Type") //multipart/form-data  vs.  application/json  vs.
        localReq.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //make the request

        do {
            
            var data: Data?
            var response: URLResponse?

            (data, response) = try await URLSession.shared.data(for: localReq, delegate: nil)

            if let resp = response {
                
                guard let resp = resp as? HTTPURLResponse else {
                    return .failure(.noResponse)
                }
                
                switch resp.statusCode {
                case 200...299:
                    if let dat = data {
                        guard let decodedResponseData = try? JSONDecoder().decode(responseModel, from: dat) else {
                            print(dat.neatenJSON())
                            return .failure(.parsingFailed)
                        }
                        return .success(decodedResponseData)
                    } else {
                        return .failure(.missingResponseData)
                    }
                case 400:
                    return .failure(.apiKeyRejected)
                case 401:
                    return .failure(.unauthorised)
                default:
                    if let dat = data {
                        print(dat.neatenJSON())
                    }
                    return .failure(.unexpectedResponseCode(resp.statusCode))
                }
                
            } else {
                return .failure(.noResponse)
            }
            

            
        } catch {
            
            return .failure(.unknown)

        }
        
    }
    
}
