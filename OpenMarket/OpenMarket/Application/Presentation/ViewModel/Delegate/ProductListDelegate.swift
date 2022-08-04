//
//  ProductListDelegate.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍. 
//

import UIKit

protocol ProductListDelegate: AnyObject {
    func productListViewController(_ viewController: ProductListViewController.Type,
                            didRecieve productListInfo: ProductListEntity)
}
