//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/13.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    var productNameLabel: UILabel!
    var productPriceLabel: UILabel!
    var productImageView: UIImageView!
    var productStockLabel: UILabel!
    var productBargainPriceLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCell()
        setUpLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
        setUpLabel()
    }
    

    func setUpCell() {
        productNameLabel = UILabel()
        productPriceLabel = UILabel()
        productImageView = UIImageView()
        productStockLabel = UILabel()
        productBargainPriceLabel = UILabel()
        productImageView.image = UIImage(named: "macmini")
        productImageView.contentMode = .scaleAspectFit
        
        
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fillEqually
            
            return stackView
        }()
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        let vStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fillEqually
            return stackView
        }()
        
        let imageStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [productImageView])
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fillEqually
            
            return stackView
        }()
        
        stackView.addArrangedSubview(imageStackView)
        stackView.addArrangedSubview(productNameLabel)
        stackView.addArrangedSubview(vStackView)
        stackView.addArrangedSubview(productStockLabel)
        productNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor).isActive = true
        productImageView.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        
        vStackView.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor).isActive = true
        
        vStackView.addArrangedSubview(productBargainPriceLabel)
        vStackView.addArrangedSubview(productPriceLabel)

    }
    
    func setUpLabel() {
        productNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        productPriceLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        productBargainPriceLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        productStockLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    }
}
