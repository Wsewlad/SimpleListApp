//
//  Reducer.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 08.08.2021.
//

import Foundation

typealias Reducer<AppState, Action> = (AppState, Action) -> AppState

let appReducer: Reducer<AppState, AppAction> = { state, action in
    var mutatingState = state
    
    mutatingState.reduce(action: action)
    
    return mutatingState
}
