//
//  BusinessResponse.swift
//  YelpFake
//
//  Created by Luan Almeida on 2025-04-05.
//

import Foundation
import SwiftData

struct Business: Identifiable, Hashable, Equatable, Decodable {
    let id: String
    let name: String
    let rating: Double
    let imageUrl: String?
    let url: String
}

struct BusinessResponse: Decodable {
    let businesses: [Business]
}

@Model
final class Favorite {
    var id: String
    
    init(id: String) {
        self.id = id
    }
}
