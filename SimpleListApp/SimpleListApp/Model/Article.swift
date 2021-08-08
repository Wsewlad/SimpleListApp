//
//  Article.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import Foundation

struct Article {
    struct Id: Hashable {
        var value: String
    }
    
    var id: Id
    var author: String
    var title: String
    var description: String
    var urlToImage: URL?
}

//MARK: - Equatable
extension Article: Equatable {
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Hashable
extension Article: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
    }
}

extension Article {
    static func fakeItem() -> Article {
        .init(
            id: .init(value: "fake"),
            author: "Author",
            title: "Title",
            description: "Description",
            urlToImage: nil
        )
    }
}

//MARK: - asArticle
extension ArticleStorable {
    var asArticle: Article {
        .init(
            id: .init(value: author + publishedAt),
            author: author,
            title: title,
            description: description,
            urlToImage: URL(string: urlToImage)
        )
    }
}
