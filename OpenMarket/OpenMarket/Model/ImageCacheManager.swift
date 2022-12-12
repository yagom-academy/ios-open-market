//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by Mangdi,Woong on 2022/12/06.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
