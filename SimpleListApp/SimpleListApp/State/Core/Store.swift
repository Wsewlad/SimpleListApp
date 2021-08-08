//
//  Store.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 08.08.2021.
//

import SwiftUI
import Combine

typealias AppStore = Store<AppState, AppAction>

final class Store<AppState, Action>: ObservableObject {
    
    @Published private(set) var state: AppState
    
    private let reducer: Reducer<AppState, Action>
    private let queue = DispatchQueue(label: "AppStore", qos: .userInitiated)
    private let middlewares: [Middleware<AppState, Action>]
    private var subscriptions: Set<AnyCancellable> = []

    init(
        state: AppState,
        reducer: @escaping Reducer<AppState, Action>,
        middlewares: [Middleware<AppState, Action>] = []
    ) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
    }
    
    func dispatch(_ action: Action) {
        queue.sync {
            self.dispatch(self.state, action)
        }
    }
    
    private func dispatch(_ currentState: AppState, _ action: Action) {
        let newState = reducer(currentState, action)
        middlewares.forEach { middleware in
            let publisher = middleware(newState, action)
            
            publisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: dispatch)
                .store(in: &subscriptions)
        }
        
        state = newState
    }
}
