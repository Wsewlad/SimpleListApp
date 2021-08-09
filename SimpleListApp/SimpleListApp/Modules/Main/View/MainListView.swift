//
//  MainListView.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import SwiftUI
import CoreData

struct MainListView: View {
    @EnvironmentObject var store: AppStore
    
    @State private var isPullToRefreshIndicatorShowing = false
    @State private var articleToOpen: Article.Id? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(store.state.newsForm.articles.elements, id: \.self) { articleId in
                        let article: Article = store.state.newsStorage.articleById[articleId] ?? .fakeItem()
    
                        ZStack {
                            Color.white.padding(-1)
                            
                            Button(action: { articleToOpen = articleId }) {
                                ArticleRowView(article: article)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }

                    ZStack {
                        Color.white.padding(-1)
                        
                        if store.state.newsFlow == .loading {
                            ProgressView()
                                .scaleEffect(2)
                                .padding(.vertical, 50)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .onAppear {
                        if !store.state.newsForm.articlesListFull {
                            store.dispatch(.loadArticles())
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Articles")
                .pullToRefresh(isShowing: $isPullToRefreshIndicatorShowing) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        store.dispatch(.loadArticles(at: 1))
                        self.isPullToRefreshIndicatorShowing = false
                    }
                }
                .onAppear {
                    if !store.state.newsForm.articlesListFull {
                        store.dispatch(.loadCashedArticles)
                        store.dispatch(.loadArticles())
                    }
                }
                
                NavigationLink(
                    destination: ArticleDetails(articleId: articleToOpen ?? Article.fakeItem().id),
                    isActive: isDetailsActive
                ) {
                    EmptyView()
                }
            }
        }
    }
}

//MARK: - Computed Properties
private extension MainListView {
    private var isDetailsActive: Binding<Bool> {
        Binding(
            get: { $articleToOpen.wrappedValue != nil },
            set: { value in
                if !value {
                    $articleToOpen.wrappedValue = nil
                }
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}
