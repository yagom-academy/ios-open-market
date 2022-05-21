//
//  CacheManager.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/16.
//

import Foundation

final class CacheManager<T: AnyObject> {
    private let cache = NSCache<NSString, T>()
    
    func set(object: T, forKey url: URL) {
        cache.setObject(object, forKey: url.absoluteString as NSString)
    }
    
    func get(forKey url: URL) -> T? {
        cache.object(forKey: url.absoluteString as NSString)
    }
    
    func clear() {
        cache.removeAllObjects()
    }
}
