//
//  BusinessListView.swift
//  YelpFake
//
//  Created by Luan Almeida on 2025-04-05.
//
import Combine
import SwiftUI

struct BusinessListView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var coordinator: NavigationCoordinator
    @StateObject var viewModel = BusinessViewModel()
    @State private var selectedBusiness: Business?
    
    var body: some View {
        NavigationView {
            switch viewModel.state {
            case .normal:
                Text("Search for a business.")
            case .loading:
                ProgressView("Loading...")
            case .autoComplete(let terms):
                List(terms, id: \.self) { term in
                    Text(term).onTapGesture {
                        Task {
                            await viewModel.fetchAutoComplete(text: term)
                        }
                    }
                }
                .listRowInsets(EdgeInsets())
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .listRowSeparator(.hidden)
                .padding(.horizontal, 0)
                .background(Color.white)
            case .filled(let businesses):
                List(businesses) { business in
                    BusinessRowView(business: business,
                                    isFavorited: viewModel.isFavorited(business),
                                    onFavorite: { business in
                        viewModel.favorite(business)
                    }, onTap: { business in
                        selectedBusiness = business
                    })
                    .onAppear {
                        Task {
                            await viewModel.loadMoreAt(last: business)
                        }
                    }
                }
                .listRowInsets(EdgeInsets())
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .buttonStyle(PlainButtonStyle())
                .listRowSeparator(.hidden)
                .padding(.horizontal, 0)
            case .error(let errorMessage):
                VStack {
                    Text(errorMessage)
                        .foregroundColor(.red)
                    Button("Retry") {
                        Task {
                            await viewModel.fetchSubmit()
                        }
                    }
                }
            case .notFound:
                Text("Any business found.")
            }
        }.navigationTitle("Yelp Fake")
            .searchable(text: $viewModel.searchQuery,
                        prompt: "Search businesses")
            .onSubmit(of: .search) {
                Task {
                    await viewModel.fetchSubmit()
                }
            }
            .onChange(of: viewModel.searchQuery) {
                Task {
                    await viewModel.autoComplete()
                }
            }.onAppear {
                viewModel.loadView(modelContext: modelContext)
            }
            .actionSheet(item: $selectedBusiness) { business in
                ActionSheet(title: Text(business.name), buttons: [
                    .default(Text("Open in Safari")) {
                        if let url = URL(string: business.url) {
                            UIApplication.shared.open(url)
                        }
                    },
                    .default(Text("Open in WebView")) {
                        coordinator.show(route: .webView(title: business.name,
                                                         url: business.url))
                    },
                    .cancel()
                ])
            }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessListView()
    }
}
