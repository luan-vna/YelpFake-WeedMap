//
//  DownloaderImage.swift
//  YelpFake
//
//  Created by Luan Almeida on 2025-04-05.
//

import UIKit

class DownloaderImage: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading: Bool = true
    private static let cache = NSCache<NSString, UIImage>()
    
    @MainActor
    func loadImage(from urlString: String) async {
        if let cachedImage = DownloaderImage.cache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            isLoading = false
            return
        }
        isLoading = true
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                self.image = uiImage
                DownloaderImage.cache.setObject(uiImage, forKey: urlString as NSString)
                isLoading = false
            }
        } catch {
            isLoading = true
            print("Failed to load image: \(error)")
        }
    }
}
