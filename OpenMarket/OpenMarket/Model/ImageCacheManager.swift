//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

final class ImageCacheManager {
  static let shared = NSCache<NSString, UIImage>()
  private init() {}
}
