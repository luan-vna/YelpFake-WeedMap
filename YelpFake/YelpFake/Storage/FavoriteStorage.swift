//
//  FavoriteStorage.swift
//  Weather
//
//  Created by Luan Almeida on 2025-04-05.
//

import SwiftData

protocol FavoriteStorageProtocol {
    
    func all() -> [Favorite]
    func insert(_ favorite: Favorite)
    func delete(_ favorite: Favorite)
}

class FavoriteStorage: FavoriteStorageProtocol {
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func all() -> [Favorite] {
        do {
            let fetchDescriptor = FetchDescriptor<Favorite>()
            let favorites: [Favorite] = try modelContext.fetch(fetchDescriptor)
            return favorites
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    func insert(_ favorite: Favorite) {
        modelContext.insert(favorite)
        try? modelContext.save()
    }
    
    func delete(_ favorite: Favorite) {
        modelContext.delete(favorite)
        try? modelContext.save()
    }
}
