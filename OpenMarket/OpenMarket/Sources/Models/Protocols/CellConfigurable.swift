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
        priceLabel.text = item.price.priceFormat(currency: item.currency.rawValue)
        priceLabel.textColor = .systemGray3
        bargainPriceLabel.text = item.bargainPrice.priceFormat(currency: item.currency.rawValue)
        
        bargainPriceLabel.isHidden = true
        
        if item.discountedPrice > 0 {
            bargainPriceLabel.isHidden = false
            priceLabel.textColor = .systemRed
            priceLabel.applyStrikethrough()
        }
        stockLabel.textColor = item.stock == 0 ? .systemOrange : .systemGray3
        stockLabel.text = item.stock == 0 ? "품절" : "잔여수량: \(item.stock)"
    }
}
