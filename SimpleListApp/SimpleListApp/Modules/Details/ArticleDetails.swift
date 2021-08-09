//
//  ArticleDetails.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 08.08.2021.
//

import SwiftUI

struct ArticleDetails: View {
    var articleId: Article.Id
    
    @EnvironmentObject var store: AppStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isLinkPresented: Bool = false
    
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
                    .if(article.url != nil) {
                        $0.sheet(isPresented: $isLinkPresented) {
                            SafariView(url: article.url!)
                        }
                    }
                
                if let _ = article.url {
                    Button(action: { isLinkPresented = true } ) {
                        HStack {
                            Text("Read the full article")
                            Image(systemName: "link")
                        }
                    }
                }
                
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

//MARK: - Computed Properties
private extension ArticleDetails {
    var article: Article {
        store.state.newsStorage.articleById[articleId] ?? .fakeItem()
    }
}

struct ArticleDetails_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArticleDetails(articleId: .init(value: "1"))
        }
    }
}
