//
//  ImageCache.swift
//  RickAndMortyApp
//
//  Created by Alberto Aragón Peci on 8/11/24.
//

import SwiftUI

class ImageCache {
    private var cache = NSCache<NSURL, UIImage>()

    func image(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }

    func store(image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}

struct AsyncImageWithCache: View {
    let url: URL
    @State private var image: Image?

    private let cache = ImageCache()

    var body: some View {
        Group {
            if let cachedImage = image {
                cachedImage
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    
    private func loadImage() {
        if let cachedImage = cache.image(for: url) {
            image = Image(uiImage: cachedImage)
        } else {
            downloadImage()
        }
    }

    private func downloadImage() {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    cache.store(image: uiImage, for: url)
                    image = Image(uiImage: uiImage)
                }
            } catch {
                print("Error loading image: \(error)")
            }
        }
    }
}
