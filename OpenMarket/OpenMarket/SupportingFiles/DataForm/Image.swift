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
//    private let session: Sessionable
    private let imageUrl: String
    // 세션을 써야한다
    init(imageUrl: String) {
//        self.session = session
        self.imageUrl = imageUrl
    }
    func loadImage(completionHandler: @escaping (UIImage) -> Void) {
        guard let url = URL(string: imageUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                guard let image = UIImage(data: data) else { fatalError() }
                completionHandler(image)
            }
            
        }.resume()
    }
}


