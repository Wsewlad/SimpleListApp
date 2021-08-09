//
//  NewsAPIClient.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import Foundation
import Combine

enum NewsAPIClient {
    //MARK: - loadArticlesPublisher
    static func loadArticlesPublisher(page: Int, pageSize: Int) -> AnyPublisher<[ArticleStorable], Error> {
        let queryDict = [
            URLParameter.page.rawValue: "\(page)",
            URLParameter.pageSize.rawValue: "\(pageSize)",
            URLParameter.country.rawValue: "us",
            URLParameter.apiKey.rawValue: kApiKey
        ]
        
        let request = URLRequest.request(
            for: .articles,
            queryDict: queryDict,
            httpMethod: .get
        )
        
        return URLSession.shared
            .validateDataTaskPublisher(request: request)
            .decode(type: [ArticleStorable].self, unwrapBy: "articles")
            .eraseToAnyPublisher()
    }
}
