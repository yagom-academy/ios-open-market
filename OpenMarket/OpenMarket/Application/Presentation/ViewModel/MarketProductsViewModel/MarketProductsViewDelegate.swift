//
//  MarketProductsViewDelegate.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍.
//

import UIKit

protocol MarketProductsViewDelegate: AnyObject {
    func didReceiveResponse(_ view: MarketProductsView.Type,
                            by data: ProductListEntity)
}
