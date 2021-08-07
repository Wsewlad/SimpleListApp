//
//  BaseAPI.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import Foundation

let kBaseURLPath: String = "https://newsapi.org"
let kApiKey: String = "4ca55b55e34241d98d709bcd5ee62b96"

let kURLTimeoutInterval: TimeInterval = 10

let kRequestHeaders: [String: String] = [
    "Content-Type": "application/json",
    "cache-control": "no-cache"
]

public enum S3BucketName: String {
    case main = "ca-general-storage"
}

//MARK: - HTTPMethod
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum HTTPHeaderField: String {
    case authorization = "Authorization"
}

//MARK: - APIError
public enum APIError: LocalizedError {
    case invalidBody
    case emptyData
    case invalidJSON
    case invalidResponse
    case statusCode(Int, Error)
    
    public var errorDescription: String? {
        if case let .statusCode(_, error) = self {
            return error.localizedDescription
        }
        
        return ""
    }
    
    public var statusCode: Int? {
        if case let .statusCode(code, _) = self {
            return code
        }
        
        return 0
    }
}

//MARK: - URLEndpoint
enum URLEndpoint: RawRepresentable {
    typealias RawValue = String
    
    case custom(urlPath: String)
    case articles
    
    init?(rawValue: RawValue) {
        fatalError()
    }
    
    var rawValue: String {
        switch self {
        case .custom(let urlPath):
            return urlPath
        case .articles:
            return "/v2/top-headlines"

        }
    }
}

//MARK: - URLParameter
enum URLParameter: String {
    case country, apiKey, page, pageSize
}

//MARK: - validate
@discardableResult
func validate(_ data: Data, _ response: URLResponse) throws -> Data {
    guard let httpResponse = response as? HTTPURLResponse else {
        throw APIError.invalidResponse
    }
    guard (200..<300).contains(httpResponse.statusCode) else {
        throw APIError.statusCode(httpResponse.statusCode, ServerError(data: data) ?? SomeError())
    }
    return data
}

func encode(_ params: [String: Any?], for httpMethod: HTTPMethod) -> Data? {
    switch httpMethod {
    case .get:
        return params.percentEscaped().data(using: .utf8)
        
    default:
        return try? JSONSerialization.data(withJSONObject: params)
    }
}
