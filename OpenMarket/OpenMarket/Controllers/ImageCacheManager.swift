//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by 노유빈 on 2022/11/23.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
