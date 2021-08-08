//
//  Actions.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 08.08.2021.
//

import Foundation

enum AppAction {
    case loadArticles(at: Int? = nil)
    case didLoadArticles(items: [Article])
    case didLoadArticlesError(text: String)
}
