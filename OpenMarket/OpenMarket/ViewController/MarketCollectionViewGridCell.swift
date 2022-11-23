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
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.setContentHuggingPriority(.init(rawValue: 10), for: .vertical)
        label.numberOfLines = 0
        return label
    }()
    
    var stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textAlignment = .center
        return label
    }()
    
    var productStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func createCellLayout() {
        [productImage, nameLabel, priceLabel, stockLabel].forEach {
            productStackView.addArrangedSubview($0)
        }
        
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = 25
        contentView.addSubview(productStackView)
        
        NSLayoutConstraint.activate([
            productImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            productImage.heightAnchor.constraint(equalTo: productImage.widthAnchor),
            
            productStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            productStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    func configureCell(page: Page) {
        createCellLayout()
        
        if let image = urlToImage(page.thumbnail) {
            productImage.image = image
        }

        if page.bargainPrice > 0  {
            priceLabel.attributedText = NSMutableAttributedString()
                .strikethrough(string: "\(page.currency.rawValue) \(page.price)")
                .normal(string: "\n\(page.currency.rawValue) \(page.bargainPrice)")
        } else {
            priceLabel.attributedText = NSMutableAttributedString()
                .normal(string: "\(page.currency.rawValue) \(page.price)")
        }
    
        nameLabel.text = page.name
        
        if page.stock == 0 {
            stockLabel.attributedText = NSMutableAttributedString()
                .orangeColor(string: "품절")
        } else {
            stockLabel.attributedText = NSMutableAttributedString()
                .normal(string: "잔여수량: \(page.stock)")
        }
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
