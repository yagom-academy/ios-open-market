//
//  ImageCacheProvider.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 24/11/2022.
//

import UIKit

class ImageCacheProvider {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
