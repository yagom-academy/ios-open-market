//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/19.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init(){}
}
