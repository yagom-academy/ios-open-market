//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/09.
//

import UIKit

class CollectionViewCellForGrid: UICollectionViewCell {
    
    static let identifier = "gridCell"
    var item: Item!
    
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
        
        textLabel.textColor = .orange
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return textLabel
    }()
    
    func configure() {
        guard let data = try? Data(contentsOf: URL(string: item.thumbnailURLs[0])!) else { return }
        
        self.product.text = item.title
        self.imageView.image = UIImage(data: data)
        self.originalPriceLabel.text = "\(item.currency) \(item.price)"
        
        if item.discountedPrice != nil {
            self.discountedPriceLabel.text = "\(item.currency) \(item.discountedPrice)"
        } else {
            self.discountedPriceLabel.text = nil
        }
        
        if item.stock == 0 {
            self.stockLable.text = "품절"
            self.stockLable.textColor = .orange
        } else {
            self.stockLable.text = "\(item.stock)"
            
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
