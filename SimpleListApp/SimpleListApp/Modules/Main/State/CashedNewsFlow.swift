//
//  CashedNewsFlow.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 09.08.2021.
//

import Foundation

enum CashedNewsFlow {
    case none, loading
    
    init() {
        self = .none
    }
    
    mutating func reduce(action: AppAction) {
        switch action {
            
        case .loadCashedArticles:
            self = .loading
            
        case .didLoadCashedArticlesError, .didLoadCashedArticles:
            self = .none
            
        default:
            break
        }
    }
}
