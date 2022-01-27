//
//  ProductUIPresenter.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/27.
//

import UIKit

struct ProductUIPresentation {
    let productNameLabelText: String
    let productNameLabelFont: UIFont
    let priceLabelText: String
    let priceLabelTextColor: UIColor
    let priceLabelIsCrossed: Bool
    let discountedLabelText: String
    let discountedLabelTextColor: UIColor
    let discountedLabelIsHidden: Bool
    let stockLabelText: String
    let stockLabelTextColor: UIColor
}

protocol ProductUIPresentable {
    func getPresentation(product: ProductPresentable, identifier: String) -> ProductUIPresentation
}

extension ProductUIPresentable {
    func getPresentation(product: ProductPresentable, identifier: String) -> ProductUIPresentation {
        let isDiscounted = product.discountedPrice != 0
        let isOutOfStock = product.stock == 0
        let defaultColor = getDefaultColor(for: identifier)
        
        return .init(productNameLabelText: product.name,
                     productNameLabelFont: UIFont.boldSystemFont(ofSize: 18),
                     priceLabelText: product.currency + CellString.space + product.price.decimalFormat!,
                     priceLabelTextColor: isDiscounted ? .red : defaultColor,
                     priceLabelIsCrossed: isDiscounted ? true : false,
                     discountedLabelText: product.currency + CellString.space + product.discountedPrice.decimalFormat!,
                     discountedLabelTextColor: defaultColor,
                     discountedLabelIsHidden: isDiscounted ? false : true,
                     stockLabelText: isOutOfStock ? CellString.outOfStock : "잔여수량: " + product.stock.stringFormat,
                     stockLabelTextColor: isOutOfStock ? .systemOrange : .systemGray
        )
    }
    
    private func getDefaultColor(for identifier: String) -> UIColor {
        switch identifier {
        case MarketCell.identifier:
            return UIColor.systemGray
        case ProductDetailsViewController.identifier:
            return UIColor.black
        default:
            return UIColor.black
        }
    }
}
