//
//  ItemCollectionViewCell.swift
//  OpenMarket
//
//  Created by seohyeon park on 2022/07/22.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewListCell {
    
    // MARK: Properties
    
    let productThumbnailImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productStockQuntityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func showPrice(priceLabel: UILabel, bargainPriceLabel: UILabel, product: SaleInformation) {
        priceLabel.text = "\(product.currency) \(product.price)"
        if product.discountedPrice == Metric.discountedPrice {
            priceLabel.textColor = .systemGray
            bargainPriceLabel.isHidden = true
        } else {
            bargainPriceLabel.isHidden = false
            priceLabel.textColor = .systemRed
            priceLabel.attributedText = priceLabel.text?.strikeThrough()
            bargainPriceLabel.text = "\(product.currency) \(product.bargainPrice)"
            bargainPriceLabel.textColor = .systemGray
        }
    }
    
    private func showSoldOut(productStockQuntity: UILabel, product: SaleInformation) {
        if product.stock == Metric.stock {
            productStockQuntity.text = CollectionViewNamespace.soldout.name
            productStockQuntity.textColor = .systemOrange
        } else {
            productStockQuntity.text = "\(CollectionViewNamespace.remainingQuantity.name) \(product.stock)"
            productStockQuntity.textColor = .systemGray
        }
    }
    
    func configureCell(product: SaleInformation, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: product.thumbnail) else { return }
        
        NetworkManager().networkPerform(for: URLRequest(url: url)) { [weak self] result in
            switch result {
            case .success(let data):
                guard let images = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    self?.productThumbnailImageView.image = images
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        self.productNameLabel.text = product.name
        
        showPrice(priceLabel: self.productPriceLabel, bargainPriceLabel: self.bargainPriceLabel, product: product)
        showSoldOut(productStockQuntity: self.productStockQuntityLabel, product: product)
    }
}
