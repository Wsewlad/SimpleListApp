//
//  NewsMiddleware.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 08.08.2021.
//

import Foundation
import Combine
import CoreData

let newsMiddleware: Middleware<AppState, AppAction> = { state, action in
    var cancellable: AnyCancellable? = nil
    
    let persistenceContex = PersistenceController.shared.container.viewContext
    
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

let cashedNewsMiddleware: Middleware<AppState, AppAction> = { state, action in
    var cancellable: AnyCancellable? = nil
    
    let persistenceContex = PersistenceController.shared.container.viewContext
    
    switch state.cashedNewsFlow {
    case .loading:
        return Deferred {
            Future<[Article], Error> { promise in
                persistenceContex.perform {
                    do {
                        let request: NSFetchRequest<CDArticle> = CDArticle.fetchRequest()
                        let cdArticles = try persistenceContex.fetch(request)
                        promise(.success(cdArticles.map(\.asArticle)))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue(label: "Cashed Articles"))
        .map { AppAction.didLoadCashedArticles(items: $0) }
        .catch { _ in Just(AppAction.didLoadCashedArticles(items: [Article]())) }
        .eraseToAnyPublisher()
        
    default:
        break
    }
    
    return Empty().eraseToAnyPublisher()
}
