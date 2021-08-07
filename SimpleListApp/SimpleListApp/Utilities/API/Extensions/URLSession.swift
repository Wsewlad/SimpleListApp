//
//  URLSession.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import Foundation
import Combine

extension URLSession {
    func validateDataTaskPublisher(request: URLRequest) -> AnyPublisher<Data, Error> {
        dataTaskPublisher(for: request)
            .tryMap { try validate($0.data, $0.response) }
            .eraseToAnyPublisher()
    }
}
