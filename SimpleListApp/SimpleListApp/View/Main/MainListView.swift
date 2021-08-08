//
//  MainListView.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import SwiftUI
import CoreData

struct MainListView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
    
//    private var items: FetchedResults<Item>
    
    @ObservedObject var viewModel = NewsListViewModel()
    @State private var isPullToRefreshIndicatorShowing = false
    @State private var articleToOpen: Article? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.articles.elements, id: \.id) { article in
                        ZStack {
                            Color.white.padding(-1)
                            
                            Button(action: { articleToOpen = article }) {
                                ArticleRowView(article: article)
                                    .onAppear {
                                        if article == viewModel.articles.elements.last && !viewModel.articlesListFull {
                                            viewModel.fetchArticles()
                                        }
                                    }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    
                    if viewModel.state == .loading {
                        ZStack {
                            Color.white.padding(-1)
                            
                            ProgressView()
                                .scaleEffect(2)
                                .padding(.vertical, 50)
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Articles")
                .pullToRefresh(isShowing: $isPullToRefreshIndicatorShowing) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        viewModel.fetchArticles(at: 1)
                        self.isPullToRefreshIndicatorShowing = false
                    }
                }
                .onAppear {
                    if !viewModel.articlesListFull {
                        viewModel.fetchArticles()
                    }
                }
                
                NavigationLink(
                    destination: ArticleDetails(article: articleToOpen ?? .fakeItem()),
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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
