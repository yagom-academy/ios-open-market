//
//  Ceche.swift
//  OpenMarket
//
//  Created by song on 2022/05/22.
//

import UIKit

struct Cache {
    static let cache = NSCache<NSURL, UIImage>()
    private init() {}
}
