//
//  NavigationCoordinator.swift
//  YelpFake
//
//  Created by Luan Almeida on 2025-04-05.
//

import SwiftUI

class NavigationCoordinator: ObservableObject {
    @Published var path: [Route] = []

    func show(route: Route) {
        path.append(route)
    }

    func pop() {
        _ = path.popLast()
    }

    func reset() {
        path.removeAll()
    }
}

enum Route: Hashable {
    case webView(title: String, url: String?)
}
