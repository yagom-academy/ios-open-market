//
//  ProductUpdateModelManager.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/20.
//

import Foundation
import UIKit.UIImage

protocol ProductUpdateModelManager: AnyObject {
    
    func process(_ form: Form) -> Bool
    var imagesDidChangeHandler: (() -> Void)? { get set }
    var currentImages: [UIImage] { get }
}

struct Form {
    let name: String?
    let price: String?
    let currency: String?
    let discountedPrice: String?
    let stock: String?
    let description: String?
}
