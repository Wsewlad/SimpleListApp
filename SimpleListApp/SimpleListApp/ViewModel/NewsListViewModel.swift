//
//  NewsListViewModel.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import Foundation
import Combine
import SwiftUI
import Collections


class NewsListViewModel: ObservableObject {
    
    @Published var articles = OrderedSet<Article>()
    @Published var state: State = .none
    
    var articlesListFull: Bool = false
    var currentPage = 0
    let perPage = 5
    
    private var cancellable: AnyCancellable? = nil
    
    func fetchArticles(at page: Int? = nil) {
        guard cancellable == nil else { return }
        
        //self.state = .loading
        
        if let cPage = page {
            articles = OrderedSet(Array(articles.elements.prefix(perPage)))
            self.currentPage = cPage
        } else {
            self.state = .loading
        }
        
        cancellable = NewsAPIClient.loadArticlesPublisher(page: currentPage, pageSize: perPage)
            .receive(on: DispatchQueue(label: "Articles"))
            .map { $0.map(\.asArticle) }
            .catch { _ in Just(self.articles.elements) }
            .sink { articles in
                self.currentPage += 1
                
                DispatchQueue.main.async {
                    for article in articles {
                        self.articles.append(article)
                    }
                    
                    self.state = .none
                }
                
                if articles.count < self.perPage {
                    self.articlesListFull = true
                }
                
                self.cancellable = nil
            }
    }
}

extension NewsListViewModel {
    enum State {
        case loading, none
    }
}
