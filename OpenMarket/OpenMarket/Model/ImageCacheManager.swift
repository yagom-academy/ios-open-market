//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/02/03.
//

import Foundation
import UIKit

struct ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
