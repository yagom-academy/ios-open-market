//
//  ImageCache.swift
//  OpenMarket
//
//  Created by Lingo, Quokka on 2022/05/20.
//

import UIKit

final class ImageCache {
  static let shared = NSCache<NSString, UIImage>()
  private init() {}
}
