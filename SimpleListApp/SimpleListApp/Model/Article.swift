//
//  Article.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import Foundation
import CoreData

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
    var url: URL?
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
            publishedAtDate: Date(),
            url: nil
        )
    }
}

//MARK: - (Storable) asArticle
extension ArticleStorable {
    var asArticle: Article {
        .init(
            id: .init(value: title + publishedAt),
            author: author,
            title: title,
            description: description,
            urlToImage: URL(string: urlToImage),
            source: source.name,
            publishedAtDate: DateFormatter().date(from: publishedAt) ?? Date(),
            url: URL(string: url)
        )
    }
}

//MARK: - asCDArticle
extension Article {
    func saveAsCDArticle(context: NSManagedObjectContext) {
        let newArticle = CDArticle(context: context)
        
        newArticle.id = id.value
        newArticle.author = author
        newArticle.title = title
        newArticle.articleDescription = description
        newArticle.source = source
        newArticle.publishedAtDate = publishedAtDate
        newArticle.urlToImage = urlToImage
        newArticle.url = url
        
        do {
            try context.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

//MARK: - (CDArticle) asArticle
extension CDArticle {
    var asArticle: Article {
        .init(
            id: .init(value: id ?? ""),
            author: author ?? "",
            title: title ?? "",
            description: articleDescription ?? "",
            urlToImage: urlToImage,
            source: source ?? "",
            publishedAtDate: publishedAtDate ?? Date(),
            url: url
        )
    }
}
