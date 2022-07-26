//
//  ItemCollectionViewCell.swift
//  OpenMarket
//
//  Created by seohyeon park on 2022/07/22.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewListCell {
    
    // MARK: Properties
    
    let productThumnail: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let productName: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bargainPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productStockQuntity: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func showPrice(priceLabel: UILabel, bargainPriceLabel: UILabel, product: SaleInformation) {
        priceLabel.text = "\(product.currency) \(product.price)"
        if product.bargainPrice == Metric.bargainPrice {
            priceLabel.textColor = .systemGray
            bargainPriceLabel.isHidden = true
        } else {
            priceLabel.textColor = .systemRed
            priceLabel.attributedText = priceLabel.text?.strikeThrough()
            bargainPriceLabel.text = "\(product.currency) \(product.price)"
            bargainPriceLabel.textColor = .systemGray
        }
    }
    
    func showSoldOut(productStockQuntity: UILabel, product: SaleInformation) {
        if product.stock == Metric.stock {
            productStockQuntity.text = "품절"
            productStockQuntity.textColor = .systemOrange
        } else {
            productStockQuntity.text = "잔여수량 : \(product.stock)"
            productStockQuntity.textColor = .systemGray
        }
    }
    
    func configureCell(product: SaleInformation) {
        guard let url = URL(string: product.thumbnail) else { return }
        
        NetworkManager().fetch(request: URLRequest(url: url)) { [weak self] result in
            switch result {
            case .success(let data):
                guard let images = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    self?.productThumnail.image = images
                }
            case .failure(_):
                MainViewController().showNetworkError(message: NetworkError.outOfRange.message)
            }
        }
        
        self.productName.text = product.name
        
        showPrice(priceLabel: self.productPrice, bargainPriceLabel: self.bargainPrice, product: product)
        showSoldOut(productStockQuntity: self.productStockQuntity, product: product)
    }
}
