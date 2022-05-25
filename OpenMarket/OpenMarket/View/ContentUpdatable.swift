//
//  ContentUpdatable.swift
//  OpenMarket
//
//  Created by 김태현 on 2022/05/24.
//

import UIKit

protocol ContentUpdatable {
    var cellUIComponent: CellUIComponent { get }
    var item: Product? { get set }
}

extension ContentUpdatable {
    @discardableResult
    func update(newItem product: Product) -> URLSessionDataTask? {
        self.cellUIComponent.nameLabel.text = product.name
        self.cellUIComponent.bargainPriceLabel.text = product.currency + String(product.bargainPrice)
        self.cellUIComponent.priceLabel.text = product.currency + String(product.price)
        
        self.setUpStockLabel(stock: product.stock)
        self.setUpPriceLabel(price: product.price, bargainPrice: product.bargainPrice)
        
        let imageFetchTask = DataProvider().fetchImage(urlString: product.thumbnail) { [self] image in
            DispatchQueue.main.async { [self] in
                cellUIComponent.thumbnailImageView.image = image
            }
        }
        return imageFetchTask
    }
    
    func setUpStockLabel(stock: Int) {
        switch stock {
        case 0:
            cellUIComponent.stockLabel.text = "품절"
            cellUIComponent.stockLabel.textColor = .systemYellow
        default:
            cellUIComponent.stockLabel.text = "잔여수량 : " + String(stock)
        }
    }
    
    func setUpPriceLabel(price: Int, bargainPrice: Int) {
        switch bargainPrice == price {
        case true:
            cellUIComponent.bargainPriceLabel.isHidden = true
        case false:
            cellUIComponent.priceLabel.attributedText = cellUIComponent.priceLabel.text?.strikeThrough()
            cellUIComponent.priceLabel.textColor = .systemRed
        }
    }
}
