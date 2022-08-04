//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by Brad on 2022/08/04.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
