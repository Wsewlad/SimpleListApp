//
//  Date.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 08.08.2021.
//

import Foundation

extension Date {
    var article: String {
        DateFormatter.article.string(from: self)
    }
}
