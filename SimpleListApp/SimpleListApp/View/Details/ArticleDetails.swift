//
//  ArticleDetails.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 08.08.2021.
//

import SwiftUI

struct ArticleDetails: View {
    var article: Article
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text(article.title)
                    .font(.title)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image.placeholder
                    .loadImageByURL(
                        article.urlToImage,
                        placeholderMode: .fill,
                        contentMode: .fill
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Text(article.description)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                HStack {
                    Text(article.publishedAtDate.article)
                    
                    Spacer()
                    
                    Text(article.author)
                }
                .font(.footnote)
                .padding(.horizontal, 5)
            }
            .padding(16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(article.source)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(uiImage: UIImage(systemName: "arrow.backward")!.withTintColor(UIColor(.gray)).withRenderingMode(.alwaysOriginal))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct ArticleDetails_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArticleDetails(article: .fakeItem())
        }
    }
}
