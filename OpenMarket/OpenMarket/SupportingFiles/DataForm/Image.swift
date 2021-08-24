//
//  Media.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/20.
//

import UIKit

struct Image {
    let key: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}

struct ImageLoader {
    private let imageUrl: String
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
    func loadImage(completionHandler: @escaping (UIImage) -> Void) {
        guard let url = URL(string: imageUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                guard let image = UIImage(data: data) else { return }
                completionHandler(image)
            }
        }.resume()
    }
}


