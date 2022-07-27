//
//  OpenMarketRepository.swift
//  OpenMarket
//
//  Created by 김동용 on 2022/07/27.
//

import UIKit
struct OpenMarketRepository {
    static func makeImage(key: String, imageView: UIImageView) {
        if let cachedImage = ImageCacheManager.shared.object(forKey: NSString(string: key)) {
            imageView.image = cachedImage
        } else {
            let request = OpenMarketRequest(path: "", method: .get, baseURL: key)
            let session = MyURLSession()
            session.execute(with: request) { (result: Result<Data, Error>) in
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
