//
//  NewsStorage.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 08.08.2021.
//

import Foundation

struct NewsStorage {
    var articleById: [Article.Id: Article] = [:]
    
    mutating func reduce(action: AppAction) {
        switch action {
        case .didLoadArticles(let items):
            for item in items {
                articleById[item.id] = item
            }
        
        default:
            break
        }
    }
}
