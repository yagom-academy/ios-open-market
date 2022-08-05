//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by minsson, yeton on 2022/08/03.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
