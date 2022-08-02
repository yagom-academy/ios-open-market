//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/23.
//

import UIKit

class ImageCacheManager {
    static let shared: NSCache<NSString, UIImage> = .init()
    
    private init() { }
}
