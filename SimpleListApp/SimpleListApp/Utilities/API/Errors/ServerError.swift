//
//  ServerError.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import Foundation

struct ServerError: LocalizedError {
    private let errorsDescription: String
    
    init?(data: Data) {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        
        errorsDescription = Self.mapJsonToErrorString(json)
    }
    
    var errorDescription: String? {
        return errorsDescription
    }
    
    private static func mapJsonToErrorString(_ json: [String: Any]) -> String {
        json.compactMap { tuple in
            if let jsonValue = tuple.value as? [String: Any] {
                return mapJsonToErrorString(jsonValue)
                
            } else if let string = tuple.value as? String {
                return tuple.key + " - " + string
                
            } else if let array = tuple.value as? [String] {
                return tuple.key + " - " + array.joined(separator: ",")
            }
            
            return nil
        }
        .joined(separator: "\n")
    }
}
