//
//  CollectionViewCellConfigurable.swift
//  OpenMarket
//
//  Created by minsson, yeton on 2022/08/03.
//

import UIKit

protocol CellConfigurable {
    var imageView: UIImageView { get }
    var nameLabel: UILabel { get }
    var priceLabel: UILabel { get }
    var bargainPriceLabel: UILabel { get }
    var stockLabel: UILabel { get }
    
    func receiveData(_ item: ItemListPage.Item)
}

extension CellConfigurable {
    func receiveData(_ item: ItemListPage.Item) {
        configureCell(with: item)
    }
}

private extension CellConfigurable {
    func configureCell(with item: ItemListPage.Item) {
        imageView.image = UIImage(systemName: "photo")
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
        
        guard let imageURL = URL(string: item.thumbnail) else {
            return
        }
        
        NetworkManager.fetchImage(from: imageURL) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.imageView.image = image
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
