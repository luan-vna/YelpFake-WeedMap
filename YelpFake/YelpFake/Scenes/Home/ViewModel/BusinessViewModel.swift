//
//  BusinessViewModel.swift
//  YelpFake
//
//  Created by Luan Almeida on 2025-04-05.
//

import Combine
import Foundation
import SwiftData
import SwiftUICore

enum BusinessState {
    case normal
    case loading
    case filled([Business])
    case error(String)
    case notFound
    case autoComplete([String])
}

@MainActor
class BusinessViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var state: BusinessState = .normal

    private var currentPage: Int = 0
    private var businesses: [Business] = []
    private var favorites: [Favorite] = []
    private let businessService: BusinessServiceProtocol
    private let autocompleteService: AutoCompleteServiceProtocol
    private var favoriteStorage: FavoriteStorageProtocol?
    
    init(businessService: BusinessServiceProtocol = BusinessService(),
         autocompleteService: AutoCompleteServiceProtocol = AutoCompleteService()) {
        self.businessService = businessService
        self.autocompleteService = autocompleteService
    }
    
    func loadView(modelContext: ModelContext) {
        self.favoriteStorage = FavoriteStorage(modelContext: modelContext)
        self.favorites = favoriteStorage?.all() ?? []
    }

    func fetchAutoComplete(text: String) async {
        searchQuery = text
        reset()
        await fetch()
    }
    
    func fetchSubmit() async {
        reset()
        await fetch()
    }
    
    private func fetch(showLoading: Bool = true) async {
        do {
            if showLoading {
                state = .loading
            }
            guard let response = try await businessService.search(term: searchQuery,
                                                                  page: currentPage) else {
                return
            }
            if currentPage == 0 && response.businesses.isEmpty {
                state = .notFound
            } else {
                let items = self.businesses + response.businesses
                self.businesses = Array(Set(items).sorted(by: { $0.name < $1.name }))
                fillIfNeedBusinesses()
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func autoComplete() async {
        guard searchQuery.count > 3 else {
            fillIfNeedBusinesses()
            return
        }
        do {
            state = .loading
            guard let response = try await autocompleteService.autocomplete(text: searchQuery) else {
                return
            }
            if response.terms.isEmpty {
                fillIfNeedBusinesses()
            } else {
                let terms = (response.terms.map { $0.text } + response.categories.map { $0.title }).sorted(by: <)
                state = .autoComplete(terms)
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    private func fillIfNeedBusinesses() {
        if businesses.isEmpty {
            state = .normal
        } else {
            state = .filled(businesses)
        }
    }
    
    func loadMoreAt(last: Business) async {
        if last == businesses.last {
            currentPage += 1
            await fetch(showLoading: false)
        }
    }
    
    func favorite(_ business: Business) {
        let favorited = favorites.first(where: { $0.id == business.id })
        if let favorited {
            favorites.removeAll { $0.id == favorited.id }
            favoriteStorage?.delete(favorited)
        } else {
            let favorite = Favorite(id: business.id)
            favorites.append(favorite)
            favoriteStorage?.insert(favorite)
        }
    }
    
    func isFavorited(_ business: Business) -> Bool {
        return favorites.contains(where: { $0.id == business.id })
    }
    
    private func reset() {
        businesses.removeAll()
        currentPage = 0
    }
}
