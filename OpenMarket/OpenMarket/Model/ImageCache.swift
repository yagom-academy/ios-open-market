//
//  dd.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/24.
//

import UIKit

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}

