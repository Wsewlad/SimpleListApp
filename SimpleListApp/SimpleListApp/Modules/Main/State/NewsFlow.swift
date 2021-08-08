//
//  NewsFlow.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 08.08.2021.
//

import Foundation

enum NewsFlow {
    case none, loading
    
    init() {
        self = .none
    }
    
    mutating func reduce(action: AppAction) {
        switch action {
        case .loadArticles:
            self = .loading
        case .didLoadArticles, .didLoadArticlesError:
            self = .none
        }
    }
}
