//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/27.
//

import Foundation
import UIKit.UIImage
import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
