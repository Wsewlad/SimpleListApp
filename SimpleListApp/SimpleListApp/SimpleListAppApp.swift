//
//  SimpleListAppApp.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import SwiftUI

private let appStore: AppStore = .init(
    state: AppState(),
    reducer: appReducer,
    middlewares: [newsMiddleware, cashedNewsMiddleware]
)

@main
struct SimpleListAppApp: App {
    var body: some Scene {
        WindowGroup {
            MainListView()
                .environmentObject(appStore)
        }
    }
}
