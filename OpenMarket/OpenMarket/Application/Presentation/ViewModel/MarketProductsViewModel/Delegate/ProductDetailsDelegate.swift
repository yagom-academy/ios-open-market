//
//  ProductDetailsDelegate.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/08/01.
//

import UIKit

protocol ProductDetailsViewDelegate: AnyObject {
    func productDetailsViewController(_ viewController: ProductDetailsViewController.Type,
                            didRecieve images: [UIImage])
    func productDetailsViewController(_ viewController: ProductDetailsViewController.Type,
                            didRecieve productInfo: ProductDetailsEntity)
}
