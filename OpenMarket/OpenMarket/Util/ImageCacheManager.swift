//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/05/17.
//

import UIKit

final class ImageCacheManager {
    let cache = NSCache<NSURL, UIImage>()
    let apiService = APIProvider<Data>()
    
    init() {
        self.cache.countLimit = 100
    }
}
