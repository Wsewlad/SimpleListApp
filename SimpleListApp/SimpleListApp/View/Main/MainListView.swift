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

    @State private var isShowing = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.articles.elements, id: \.id) { article in
                    ZStack {
                        Color.white.padding(-1)
                        
                        ArticleRowView(article: article)
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .onAppear {
                                if article == viewModel.articles.elements.last && !viewModel.articlesListFull {
                                    viewModel.fetchArticles()
                                }
                            }
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
            .pullToRefresh(isShowing: $isShowing) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    viewModel.fetchArticles(at: 1)
                    self.isShowing = false
                }
            }
            .onAppear {
                if !viewModel.articlesListFull {
                    viewModel.fetchArticles()
                }
            }
        }
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
