//
//  View.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 08.08.2021.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
