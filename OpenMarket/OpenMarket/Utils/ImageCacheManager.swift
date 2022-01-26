//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/26.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
