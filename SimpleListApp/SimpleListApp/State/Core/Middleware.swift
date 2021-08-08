//
//  Middleware.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 08.08.2021.
//

import Foundation

import Combine

typealias Middleware<AppState, Action> =
  (AppState, Action) -> AnyPublisher<Action, Never>
