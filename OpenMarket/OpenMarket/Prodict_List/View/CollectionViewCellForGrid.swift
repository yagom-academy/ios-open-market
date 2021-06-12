//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/09.
//

import UIKit

class CollectionViewCellForGrid: UICollectionViewCell {
    
    static let identifier = "gridCell"
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.backgroundColor = .white
        
        return stackView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage.init(named: "yagom")
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var product: UILabel = {
        var textLabel = UILabel()
        textLabel.text = "야곰아카데미"
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return textLabel
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.backgroundColor = .white
        
        return stackView
    }()
    
    var discountedPriceLabel: UILabel = {
        var textLabel = UILabel()
        textLabel.text = "USD 1,000"
        textLabel.textColor = .lightGray
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return textLabel
    }()
    
    var originalPriceLabel: UILabel = {
        var textLabel = UILabel()
        textLabel.text = "USD 2,000"
        textLabel.textColor = .lightGray
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        return textLabel
    }()
    
    var stockLable: UILabel = {
        var textLabel = UILabel()
        var stock: Int = 0
        
        if stock == 0 {
            textLabel.text = "품절"
        } else {
            textLabel.text = "\(stock)"
        }
        
        textLabel.textColor = .orange
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return textLabel
    }()
    
    func configure(product: String, images: [String], originalPrice: Int,  discountedPrice: Int?, currency: String, stock: Int) {
        self.product.text = product
        self.imageView.image = UIImage(named: images[0])
        self.originalPriceLabel.text = "\(currency) \(originalPrice)"
        
        if discountedPrice != nil {
            self.discountedPriceLabel.text = "\(currency) \(discountedPriceLabel)"
        } else {
            self.discountedPriceLabel.text = nil
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(mainStackView)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGray2.cgColor
        self.layer.cornerRadius = 5
        
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(product)
        mainStackView.addArrangedSubview(priceStackView)
        mainStackView.addArrangedSubview(stockLable)
        
        priceStackView.addArrangedSubview(originalPriceLabel)
        priceStackView.addArrangedSubview(discountedPriceLabel)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
            
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            priceStackView.heightAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.25)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
