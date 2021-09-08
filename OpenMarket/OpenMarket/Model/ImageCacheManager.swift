//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/09/08.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
