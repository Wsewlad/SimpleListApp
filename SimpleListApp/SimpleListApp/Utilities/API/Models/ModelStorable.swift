//
//  ModelStorable.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import Foundation

public struct ModelStorable: Codable {
    public var id: Int
    public var value: String
    public var value2: [String]
}

// MARK: - CodingKey
public extension ModelStorable {
    enum CodingKeys: String, CodingKey {
        case id, value
        case value2 = "value_2"
    }
}

// MARK: - Decoding
public extension ModelStorable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = container.decodeSafely(.id) ?? 0
        value = container.decodeSafely(.value) ?? ""
        value2 = container.decodeSafely(.value2) ?? []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(value, forKey: .value)
        try container.encode(value2, forKey: .value2)
    }
}
