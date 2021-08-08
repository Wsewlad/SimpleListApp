//
//  NewsMiddleware.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 08.08.2021.
//

import Foundation

import Combine

let newsMiddleware: Middleware<AppState, AppAction> = { state, action in
    var cancellable: AnyCancellable? = nil
    
    switch state.newsFlow {
    case .loading:
        return NewsAPIClient.loadArticlesPublisher(page: state.newsForm.currentPage, pageSize: state.newsForm.perPage)
            .receive(on: DispatchQueue(label: "Articles"))
            .map { AppAction.didLoadArticles(items: $0.map(\.asArticle)) }
            .catch { _ in Just(AppAction.didLoadArticles(items: [Article]())) }
            .eraseToAnyPublisher()
        
    default:
        break
    }
    
    return Empty().eraseToAnyPublisher()
}
