//
//  SomeError.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import Foundation

struct SomeError: LocalizedError {
    var errorDescription: String? {
        return "Some error occurred. Please try again later"
    }
}
