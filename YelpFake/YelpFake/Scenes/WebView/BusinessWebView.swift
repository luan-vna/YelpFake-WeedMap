//
//  WebViewScreen.swift
//  YelpFake
//
//  Created by Luan Almeida on 2025-04-05.
//

import SwiftUI

struct BusinessWebView: View {
    
    private let title: String
    private var url: URL? = nil
    
    init(title: String, url string: String?) {
        self.title = title
        if let string = string {
            self.url = URL(string: string)
        }
    }

    var body: some View {
        if let url = url {
            WebView(url: url)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
