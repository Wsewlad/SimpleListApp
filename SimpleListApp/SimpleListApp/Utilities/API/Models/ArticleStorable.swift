//
//  ArticleStorable.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import Foundation

public struct ArticleStorable: Codable {
    public var author: String
    public var title: String
    public var description: String
    public var urlToImage: String
    public var publishedAt: String
}

// MARK: - CodingKey
public extension ArticleStorable {
    enum CodingKeys: String, CodingKey {
        case author, title, description, urlToImage, publishedAt
    }
}

// MARK: - Decoding
public extension ArticleStorable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        author = container.decodeSafely(.author) ?? ""
        title = container.decodeSafely(.title) ?? ""
        description = container.decodeSafely(.description) ?? ""
        urlToImage = container.decodeSafely(.urlToImage) ?? ""
        publishedAt = container.decodeSafely(.publishedAt) ?? ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(author, forKey: .author)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(urlToImage, forKey: .urlToImage)
        try container.encode(publishedAt, forKey: .publishedAt)
    }
}
