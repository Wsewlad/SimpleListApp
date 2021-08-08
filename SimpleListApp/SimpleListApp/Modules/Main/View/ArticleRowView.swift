//
//  ArticleRowView.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import SwiftUI

struct ArticleRowView: View {
    var article: Article
    
    var body: some View {
        VStack(spacing: 10) {
            Image.placeholder
                .loadImageByURL(article.urlToImage, placeholderMode: .fill, contentMode: .fill)
                .frame(height: 120)
                .clipped()
            
            VStack(spacing: 5) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Text(article.description)
                    .font(.body)
                    .lineLimit(3)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                HStack {
                    Spacer()
                    
                    Text("Read more")
                        .font(.callout)
                    
                    Image(systemName: "newspaper")
                }
            }
            .padding([.horizontal, .bottom], 10)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(radius: 4)
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRowView(article: .fakeItem())
    }
}
