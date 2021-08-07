//
//  Publisher+UnwrapDecoding.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import Foundation

import Combine

extension Publisher {
    func decodeUnwrap<Item: Decodable>(type: Item.Type) -> Publishers.Map<Publishers.Decode<Self, UnwrapContainer<Item>, JSONDecoder>, Item> {
        self.decode(type: type, decoder: JSONDecoder(), unwrapBy: "")
    }
    
    func decodeUnwrap<Item: Decodable, Coder: UnwrapDecoder>(
        type: Item.Type,
        decoder: Coder
    ) -> Publishers.Map<Publishers.Decode<Self, UnwrapContainer<Item>, Coder>, Item> {
        self.decode(type: type, decoder: decoder, unwrapBy: "")
    }
    
    func decode<Item: Decodable>(
        type: Item.Type,
        unwrapBy key: String
    ) -> Publishers.Map<Publishers.Decode<Self, UnwrapContainer<Item>, JSONDecoder>, Item> {
        self.decode(type: type, decoder: JSONDecoder(), unwrapBy: key)
    }
    
    func decode<Item: Decodable, Coder: UnwrapDecoder>(
        type: Item.Type,
        decoder: Coder,
        unwrapBy key: String
    ) -> Publishers.Map<Publishers.Decode<Self, UnwrapContainer<Item>, Coder>, Item> where Self.Output == Coder.Input {
        var mutableDecoder = decoder
        if let codingKey = CodingUserInfoKey(rawValue: kUnwrapKey), !key.isEmpty {
            mutableDecoder.userInfo[codingKey] = key
        }
        
        return Publishers.Map(
            upstream: self.decode(type: UnwrapContainer<Item>.self, decoder: mutableDecoder),
            transform: { $0.value }
        )
    }
}

let kUnwrapKey = "unwrap_key"

//MARK: - UnwrapContainer
struct UnwrapContainer<Value: Decodable>: Decodable {
    let value: Value
    
    private struct DynamicCodingKeys: CodingKey {
        
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let keys = container.allKeys
        
        if let codingKey = CodingUserInfoKey(rawValue: kUnwrapKey),
           let wrapKey = decoder.userInfo[codingKey] as? String,
           let decodeKey = DynamicCodingKeys(stringValue: wrapKey)
        {
            value = try container.decode(decodeKey)
        } else {
            value = try container.decode(keys.first!)
        }
    }
}

//MARK: - UnwrapDecoder
public protocol UnwrapDecoder: TopLevelDecoder {
    var userInfo: [CodingUserInfoKey : Any] { get set }
}

extension JSONDecoder: UnwrapDecoder {}
