//
//  ArticleStorable.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import Foundation

struct ArticleStorable: Codable {
    var author: String
    var title: String
    var description: String
    var urlToImage: String
    var publishedAt: String
    var source: SourceStorable
    var url: String
}

// MARK: - CodingKey
extension ArticleStorable {
    enum CodingKeys: String, CodingKey {
        case author, title, description, urlToImage, publishedAt, source, url
    }
}

// MARK: - Decoding
extension ArticleStorable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        author = container.decodeSafely(.author) ?? ""
        title = container.decodeSafely(.title) ?? ""
        description = container.decodeSafely(.description) ?? ""
        urlToImage = container.decodeSafely(.urlToImage) ?? ""
        publishedAt = container.decodeSafely(.publishedAt) ?? ""
        source = try container.decode(.source)
        url = container.decodeSafely(.url) ?? ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(author, forKey: .author)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(urlToImage, forKey: .urlToImage)
        try container.encode(publishedAt, forKey: .publishedAt)
        try container.encode(source, forKey: .source)
        try container.encode(url, forKey: .url)
    }
}
