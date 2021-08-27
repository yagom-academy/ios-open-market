//
//  OpenMarketImageCache.swift
//  OpenMarket
//
//  Created by Do Yi Lee on 2021/08/26.
//

import UIKit

class ImageCacher: NSCache<NSNumber, UIImage> {
    static let shared = ImageCacher()
    
    private override init() {
        super.init()
        self.countLimit = 100
    }
    
    func save(_ image: UIImage, forkey: Int) {
        setObject(image, forKey: NSNumber(value: forkey))
    }
    
    func pullImage(forkey: Int) -> UIImage? {
        guard let image = object(forKey: NSNumber(value: forkey)) else {
            return nil
        }
        return image
    }
}
