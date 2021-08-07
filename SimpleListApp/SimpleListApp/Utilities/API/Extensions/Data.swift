//
//  Data.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import Foundation

extension Data {
    func unwrapJSONDataBy(key: String) -> Data {
        guard let json = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] else {
            return self
        }
        
        guard let jsonByKey = json[key] else {
            return self
        }
        
        guard let newData = try? JSONSerialization.data(withJSONObject: jsonByKey, options: .fragmentsAllowed) else {
            return self
        }
        
        return newData
    }
}
