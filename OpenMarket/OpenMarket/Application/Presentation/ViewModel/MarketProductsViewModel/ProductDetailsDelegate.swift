//
//  ProductDetailsDelegate.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/08/01.
//

import UIKit

protocol ProductDetailsViewDelegate: AnyObject {
    func didReceiveResponse(_ viewController: ProductDetailViewController.Type,
                            by data: [UIImage])
}
