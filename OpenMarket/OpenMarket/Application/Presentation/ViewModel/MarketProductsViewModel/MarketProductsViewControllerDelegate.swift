//
//  MarketProductsViewControllerDelegate.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍.
//

import UIKit

protocol MarketProductsViewControllerDelegate: AnyObject {
    func didReceiveResponse(_ view: MarketProductsViewController.Type,
                            by data: ProductListEntity)
}
