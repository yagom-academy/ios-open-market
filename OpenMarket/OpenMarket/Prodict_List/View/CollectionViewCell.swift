//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/09.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
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
    
    let product: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "야곰아카데미"
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return textLabel
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.backgroundColor = .white
        
        return stackView
    }()
    
    let discountedPriceLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "USD 1,000"
        textLabel.textColor = .lightGray
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.contentCompressionResistancePriority(for: .vertical)
        
        return textLabel
    }()
    
    let originalPriceLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "USD 2,000"
        textLabel.textColor = .lightGray
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(product)
        mainStackView.addArrangedSubview(priceStackView)
        
        priceStackView.addArrangedSubview(originalPriceLabel)
        priceStackView.addArrangedSubview(discountedPriceLabel)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            priceStackView.heightAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.25)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
