//
//  Image.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import SwiftUI

extension Image {
    static var placeholder: Image = Image("placeholder")
}

extension Image {
    var original: Self {
        self.renderingMode(.original)
    }
    
    var template: Self {
        self.renderingMode(.template)
    }
    
    func aspectFit() -> some View {
        self.resizable().aspectRatio(contentMode: .fit)
    }
    
    func aspectFill()  -> some View {
        self.resizable().aspectRatio(contentMode: .fill)
    }
}
