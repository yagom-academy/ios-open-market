//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by Mangdi on 2022/11/24.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
