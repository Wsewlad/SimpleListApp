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
    var source: String
    var publishedAtDate: Date
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
            author: "BBC News",
            title: "Capitol riot: Off-duty Seattle police officers fired over assault",
            description: "The officers stood by as Donald Trump's supporters stormed the government building, an inquiry says.",
            urlToImage: URL(string: "https://ichef.bbci.co.uk/news/1024/branded_news/B228/production/_119080654_gettyimages-1230455457-594x594.jpg"),
            source: "BBC",
            publishedAtDate: Date()
        )
    }
}

//MARK: - asArticle
extension ArticleStorable {
    var asArticle: Article {
        .init(
            id: .init(value: title + publishedAt),
            author: author,
            title: title,
            description: description,
            urlToImage: URL(string: urlToImage),
            source: source.name,
            publishedAtDate: DateFormatter().date(from: publishedAt) ?? Date()
        )
    }
}
