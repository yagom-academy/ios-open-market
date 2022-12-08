//  ListCollectionViewCell.swift
//  OpenMarket
//  Created by SummerCat on 2022/11/29.

import UIKit

final class ListCollectionViewCell: UICollectionViewCell, CollectionViewCellType {
    var product: Product?
    var task: URLSessionDataTask?
    
    required init?(coder: NSCoder) {
        fatalError("This view should not be initialized via storyboard.")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        task?.cancel()
        task = nil
        productImageView.image = .none
        productNameLabel.text = .none
        priceLabel.attributedText = nil
        bargainPriceLabel.text = nil
        stockLabel.attributedText = nil
    }
    
    var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    var productNameLabel = UILabel.createLabel(font: .preferredFont(forTextStyle: .headline), textAlignment: .left)
    
    var stockLabel = UILabel.createLabel(font: .preferredFont(forTextStyle: .body), textAlignment: .right, textColor: .gray)
    
    private let disclosureButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(systemName: "chevron.forward")
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stockLabelAndDisclosureButtonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.setContentHuggingPriority(.required, for: .horizontal)
        return stack
    }()
    
    private let upperLineStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    var priceLabel = UILabel.createLabel(font: .preferredFont(forTextStyle: .body), textAlignment: .left, textColor: .gray)
    
    var bargainPriceLabel = UILabel.createLabel(font: .preferredFont(forTextStyle: .body), textAlignment: .left, textColor: .gray)
    
    private let priceStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    private let productDetailStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    private let cellStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
    private func configureUI() {
        stockLabelAndDisclosureButtonStackView.addArrangedSubview(stockLabel)
        stockLabelAndDisclosureButtonStackView.addArrangedSubview(disclosureButton)
        stockLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        upperLineStackView.addArrangedSubview(productNameLabel)
        upperLineStackView.addArrangedSubview(stockLabelAndDisclosureButtonStackView)
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(bargainPriceLabel)
        
        priceLabel.setContentHuggingPriority(.required, for: .horizontal)
    
        productDetailStackView.addArrangedSubview(upperLineStackView)
        productDetailStackView.addArrangedSubview(priceStackView)
        
        cellStackView.addArrangedSubview(productImageView)
        cellStackView.addArrangedSubview(productDetailStackView)
        
        contentView.addSubview(cellStackView)
        
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),
            
            disclosureButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            disclosureButton.widthAnchor.constraint(equalTo: disclosureButton.heightAnchor)
        ])
        
        let priceWidth = priceLabel.widthAnchor.constraint(lessThanOrEqualTo: priceStackView.widthAnchor, multiplier: 0.5)
        priceWidth.priority = .defaultLow
        priceWidth.isActive = true
    }
}
