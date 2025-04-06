//
//  BusinessRowView.swift
//  YelpFake
//
//  Created by Luan Almeida on 2025-04-05.
//

import SwiftUI

struct BusinessRowView: View {
    let business: Business
    @StateObject private var downloaderImage = DownloaderImage()
    @State var isFavorited = false
    
    var onFavorite: ((Business) -> Void)? = nil
    var onTap: ((Business) -> Void)? = nil
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottomLeading) {
                if let urlString = business.imageUrl {
                    Group {
                        if downloaderImage.isLoading {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else if let image = downloaderImage.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }.onTapGesture {
                        onTap?(business)
                    }
                    .task {
                        await downloaderImage.loadImage(from: urlString)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(business.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Rating: \(business.rating, specifier: "%.1f") ⭐")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }.onTapGesture {
                    onTap?(business)
                }
                .padding()
                .background(
                    Color.black.opacity(0.5)
                        .blur(radius: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                .padding()
            }

            Button(action: {
                isFavorited.toggle()
                onFavorite?(business)
            }) {
                Image(systemName: isFavorited ? "heart.fill" : "heart")
                    .foregroundColor(isFavorited ? .red : .white)
                    .padding(12)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
                    .padding([.top, .trailing], 12)
            }
        }
        .listRowSeparator(.hidden)
    }
}
