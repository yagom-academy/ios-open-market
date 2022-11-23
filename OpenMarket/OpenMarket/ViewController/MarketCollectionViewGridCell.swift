//
//  MarketCollectionViewGridCell.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/23.
//

import UIKit

class MarketCollectionViewGridCell: UICollectionViewCell {
    var productImage: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .center
        
        return label
    }()
    
    var stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    func createCellLayout() {
        [productImage, nameLabel, priceLabel, stockLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            productImage.heightAnchor.constraint(equalTo: productImage.widthAnchor),
            productImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            priceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            stockLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            stockLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stockLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configureCell(page: Page) {
        createCellLayout()
        
        if let image = urlToImage(page.thumbnail) {
            productImage.image = image
        }
        nameLabel.text = page.name
        priceLabel.text = "\(page.currency) \(page.price)"
        stockLabel.text = page.stock == 0 ? "품절" : "\(page.stock)"
    }
    
    func urlToImage(_ urlString: String) -> UIImage? {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
}
