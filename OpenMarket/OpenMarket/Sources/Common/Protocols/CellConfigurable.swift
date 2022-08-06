//
//  CollectionViewCellConfigurable.swift
//  OpenMarket
//
//  Created by minsson, yeton on 2022/08/03.
//

import UIKit

protocol CellConfigurable: AnyObject {
    
    // MARK: - Requirements
    
    var imageView: UIImageView { get }
    var nameLabel: UILabel { get }
    var priceLabel: UILabel { get }
    var bargainPriceLabel: UILabel { get }
    var stockLabel: UILabel { get }
    var imageRequest: URLSessionTask? { get set }
    
    func receiveData(_ item: ItemListPage.Item)
}

// MARK: - Actions

extension CellConfigurable {
    func receiveData(_ item: ItemListPage.Item) {
        configureCell(with: item)
    }
}

// MARK: - Private Actions

private extension CellConfigurable {
    func configureCell(with item: ItemListPage.Item) {
        imageRequest = imageView.setImageURL(item.thumbnail)
    
        nameLabel.text = item.name
        priceLabel.text = item.price.applyFormat(currency: item.currency)
        priceLabel.textColor = Color.priceLabel
        bargainPriceLabel.text = item.bargainPrice.applyFormat(currency: item.currency)
        
        if item.discountedPrice == 0 {
            bargainPriceLabel.isHidden = true
        } else {
            bargainPriceLabel.isHidden = false
            priceLabel.textColor = Color.priceLabelDiscounted
            priceLabel.applyStrikethrough()
        }
        
        if item.stock == 0 {
            stockLabel.textColor = Color.stockLabelSoldOut
            stockLabel.text = "품절"
        } else {
            stockLabel.textColor = Color.stockLabel
            stockLabel.text = "잔여수량: \(item.stock)"
        }
    }
}
