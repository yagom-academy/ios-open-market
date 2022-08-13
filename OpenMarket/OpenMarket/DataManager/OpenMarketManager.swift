//
//  OpenMarketManager.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/27.
//

import UIKit.UIImage

struct OpenMarketManager {
    static func setupImage(key: String, completion: @escaping (UIImage) -> Void) {
        if let cachedImage = ImageCacheManager.shared.object(forKey: NSString(string: key)) {
            completion(cachedImage)
        } else {
            let request = ImageGetRequest(baseURL: key)
            
            let session = MyURLSession()
            session.execute(with: request) { (result: Result<Data, Error>) in
                switch result {
                case .success(let success):
                    guard let image = UIImage(data: success) else { return }
                    
                    if ImageCacheManager.shared.object(forKey: NSString(string: key)) == nil {
                        ImageCacheManager.shared.setObject(image,
                                                           forKey: NSString(string: key))
                    }
                    
                   completion(image)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
}
