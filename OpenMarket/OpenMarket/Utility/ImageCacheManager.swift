//
//  CacheManager.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/08/01.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
