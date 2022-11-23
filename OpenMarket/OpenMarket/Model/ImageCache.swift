//
//  ImageCache.swift
//  OpenMarket
//
//  Created by Ayaan on 2022/11/23.
//

import UIKit.UIImage

struct ImageCache {
    typealias ImageURLString = NSString
    static var shared: NSCache<ImageURLString, UIImage> = .init()
}
