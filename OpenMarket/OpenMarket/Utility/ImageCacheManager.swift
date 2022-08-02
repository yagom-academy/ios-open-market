//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/22.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
