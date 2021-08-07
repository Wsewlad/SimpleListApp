//
//  NewsListViewModel.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import Foundation
import Combine
import SwiftUI

class NewsListViewModel: ObservableObject {
    
    @Published var articles = [Article]()
    
    var articlesListFull: Bool = false
    var currentPage = 0
    let perPage = 20
    
    private var cancellable: AnyCancellable? = nil
    
    func fetchArticles(at page: Int? = nil) {
        guard cancellable == nil else { return }
        
        if let cPage = page {
            articles = []
            self.currentPage = cPage
        }
        
        cancellable = NewsAPIClient.loadArticlesPublisher(page: currentPage, pageSize: perPage)
            .receive(on: DispatchQueue(label: "Articles"))
            .map { $0.map(\.asArticle) }
            .catch { _ in Just(self.articles) }
            .sink { articles in
                self.currentPage += 1
                
                DispatchQueue.main.async {
                    self.articles.append(contentsOf: articles)
                }
                
                if articles.count < self.perPage {
                    self.articlesListFull = true
                }
                
                self.cancellable = nil
            }
    }
}
