//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by 김동용 on 2022/07/23.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() { }
}
