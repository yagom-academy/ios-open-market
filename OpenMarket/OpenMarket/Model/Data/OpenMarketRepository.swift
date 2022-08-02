//
//  OpenMarketRepository.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/27.
//

import UIKit
struct OpenMarketRepository {
    static func makeImage(key: String, imageView: UIImageView) {
        if let cachedImage = ImageCacheManager.shared.object(forKey: NSString(string: key)) {
            imageView.image = cachedImage
        } else {
            var request = OpenMarketRequest(baseURL: key)
            let session = MyURLSession()
            session.execute(with: request.SetGetImageRequest()) { (result: Result<Data, Error>) in
                switch result {
                case .success(let success):
                    guard let image = UIImage(data: success) else { return }
                    if ImageCacheManager.shared.object(forKey: NSString(string: key)) == nil {
                        ImageCacheManager.shared.setObject(image, forKey: NSString(string: key))
                    }
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
}
