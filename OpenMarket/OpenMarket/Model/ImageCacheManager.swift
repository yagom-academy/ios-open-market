//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/19.
//

import UIKit

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let imageCache = NSCache<NSString, UIImage>()
    
    func getImage(key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
    
    func saveImage(key: String, image: UIImage) {
        imageCache.setObject(image, forKey: key as NSString)
    }
    
    private init(){}
}
