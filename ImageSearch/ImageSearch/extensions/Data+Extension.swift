//
//  Data+Extension.swift
//  PixabaySearchDemo
//
//  Created by Matthew Magee on 18/08/2022.
//

import Foundation

extension Data {
    
    func neatenJSON() -> String {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            return(String(decoding: jsonData, as: UTF8.self))
        } else {
            assertionFailure("Malformed JSON")
        }
        return "Unable to neaten JSON"
    }
    
}
