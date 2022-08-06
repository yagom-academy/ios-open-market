//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

final class ImageCacheManager {
    static var shared = NSCache<NSString, UIImage>()
    private init() {}
}
