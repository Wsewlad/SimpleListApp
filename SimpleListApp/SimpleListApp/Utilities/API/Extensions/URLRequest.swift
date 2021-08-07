//
//  URLRequest.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import Foundation

extension URLRequest {
    static func request(
        for endpoint: URLEndpoint,
        queryDict: [String: String?] = [:],
        httpMethod: HTTPMethod = .get,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = kURLTimeoutInterval
    ) -> URLRequest {
        guard let string = (kBaseURLPath + endpoint.rawValue).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            var components = URLComponents(string: string) else {
                fatalError("url can't be nil")
        }
        
        if case let .custom(customUrlPath) = endpoint, let customComponents = URLComponents(string: customUrlPath) {
            components = customComponents
        }
        
        components.queryItems = queryDict.map { URLQueryItem(name: $0, value: $1) }
        
        guard let url = components.url else {
            fatalError("url can't be nil")
        }
        
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = kRequestHeaders
        return request
    }
}
