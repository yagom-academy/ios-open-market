//
//  ProductUpdateModelManager.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/20.
//

import Foundation
import UIKit.UIImage

protocol ProductUpdateModelManager: AnyObject {
    
    func process(_ form: ProductRegisterForm) -> Bool
    func append(image: UIImage)
    
    var imagesDidChangeHandler: (() -> Void)? { get set }
    var currentImages: [UIImage] { get }
    var canAddImage: Bool { get }
}
