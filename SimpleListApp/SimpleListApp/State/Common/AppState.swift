//
//  AppState.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 08.08.2021.
//

import Foundation

struct AppState {
    var newsForm = NewsForm()
    var newsFlow = NewsFlow()
    var newsStorage = NewsStorage()
    
    mutating func reduce(action: AppAction) {
        newsForm.reduce(action: action)
        newsFlow.reduce(action: action)
        newsStorage.reduce(action: action)
    }
}

