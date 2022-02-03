//
//  ItemCache.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/02/03.
//

import Foundation

class ProductDetailsCache: NSCache<NSString, StructWrapper<ProductDetails>> {
    static let shared = ProductDetailsCache()
    
    private override init() {}
    
    func cache(_ product: ProductDetails, for key: Int) {
        let keyString = NSString(format: "%d", key)
        let productWrapper = StructWrapper(product)
        self.setObject(productWrapper, forKey: keyString)
    }
    
    func getProduct(for key: Int) -> ProductDetails? {
        let keyString = NSString(format: "%d", key)
        let productWrapper = self.object(forKey: keyString)
        return productWrapper?.value
    }
}
