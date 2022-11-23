//
//  ListCell.swift
//  OpenMarket
//
//  Created by Jpush, Aaron on 2022/11/22.
//

import UIKit

class ListCell: UICollectionViewListCell {
    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let productName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    
    let price: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    
    let bargainPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    
    let stock: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let nameStockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    let labelStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    let containerStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal

        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.accessories = [.disclosureIndicator()]
        
        self.contentView.addSubview(containerStackView)
        
        self.containerStackView.addArrangedSubview(image)
        self.containerStackView.addArrangedSubview(labelStackView)
        
        self.labelStackView.addArrangedSubview(nameStockStackView)
        self.labelStackView.addArrangedSubview(priceStackView)
        
        self.nameStockStackView.addArrangedSubview(productName)
        self.nameStockStackView.addArrangedSubview(stock)
        
        self.priceStackView.addArrangedSubview(price)
        self.priceStackView.addArrangedSubview(bargainPrice)
        
        setUpUI()
    }
    
    func setUpUI() {
        NSLayoutConstraint.activate([
            
            
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            image.widthAnchor.constraint(equalToConstant: 100),
            image.heightAnchor.constraint(equalTo: image.widthAnchor)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
