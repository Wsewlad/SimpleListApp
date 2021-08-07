//
//  CustomError.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import Foundation

struct CustomError: LocalizedError {
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    var errorDescription: String? {
        NSLocalizedString(text, comment: "")
    }
}
