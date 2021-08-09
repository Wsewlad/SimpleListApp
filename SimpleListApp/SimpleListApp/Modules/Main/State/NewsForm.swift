//
//  NewsForm.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 08.08.2021.
//

import Foundation
import Collections

struct NewsForm {
    var articles: OrderedSet<Article.Id> = []
    
    let perPage = 5
    var articlesListFull: Bool = false
    var currentPage = 0
    
    var error: String? = nil
    
    mutating func reduce(action: AppAction) {
        switch action {
        case .loadArticles(let page):
            if let newPage = page {
                currentPage = newPage
            }
            
        case .didLoadArticles(let items):
            for item in items {
                articles.append(item.id)
            }
            
            if !items.isEmpty {
                currentPage += 1
            }
            
            if items.count < self.perPage {
                self.articlesListFull = true
            }
            
        case .didLoadCashedArticles(let items):
            for item in items {
                articles.append(item.id)
            }
        
        case .didLoadArticlesError(let errorText):
            self.error = errorText
            
        default:
            break
        }
    }
}
