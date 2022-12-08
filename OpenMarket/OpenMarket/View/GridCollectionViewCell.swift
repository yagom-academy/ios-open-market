//  GridCollectionViewCell.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/25.

import UIKit

final class GridCollectionViewCell: UICollectionViewCell, CollectionViewCellType {
    var product: Product? {
        didSet {
            updateImage(product)
            updateContents(product)
        }
    }
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
    
    let productNameLabel = UILabel.createLabel(font: .preferredFont(forTextStyle: .headline), textAlignment: .center)

    var priceLabel = UILabel.createLabel(font: .preferredFont(forTextStyle: .body), textAlignment: .center, textColor: .gray)

    var bargainPriceLabel = UILabel.createLabel(font: .preferredFont(forTextStyle: .body), textAlignment: .center, textColor: .gray)
    
    var stockLabel = UILabel.createLabel(font: .preferredFont(forTextStyle: .body), textAlignment: .center, textColor: .gray)
    
    private let priceStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private let parentPriceStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    private let cellStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    private func configureUI() {
        contentView.addSubview(cellStackView)
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(bargainPriceLabel)
        
        parentPriceStackView.addArrangedSubview(priceStackView)
        
        cellStackView.addArrangedSubview(productImageView)
        cellStackView.addArrangedSubview(productNameLabel)
        cellStackView.addArrangedSubview(parentPriceStackView)
        cellStackView.addArrangedSubview(stockLabel)
        
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalTo: cellStackView.widthAnchor, multiplier: 0.95),
            productImageView.heightAnchor.constraint(equalTo: cellStackView.heightAnchor, multiplier: 0.6),
            
            productNameLabel.heightAnchor.constraint(equalTo: cellStackView.heightAnchor, multiplier: 0.1),
            
            parentPriceStackView.heightAnchor.constraint(equalTo: cellStackView.heightAnchor, multiplier: 0.2),
            
            stockLabel.heightAnchor.constraint(equalTo: cellStackView.heightAnchor, multiplier: 0.1)
        ])
        
        contentView.backgroundColor = .systemBackground
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
    }
}
