//
//  ItemListCollectionViewCell.swift
//  OpenMarket
//
//  Created by minsson, yeton on 2022/07/26.
//

import UIKit

final class ItemListCollectionViewCell: UICollectionViewCell, CellConfigurable {
    
    // MARK: - Properties
    
    var imageRequest: URLSessionTask?
    
    // MARK: - UI Properties
    
    private let entireHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let informationLabelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let firstRowHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let stockAndAccessoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        label.textColor = Color.stockLabel
        return label
    }()
    
    let accessaryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "greaterthan")
        imageView.tintColor = Color.accessaryImageView
        return imageView
    }()
    
    private let secondRowHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.priceLabel
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.bargainPriceLabel
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        arrangeSubView()
        setupUIComponentsLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let imageRequest = imageRequest { 
            imageRequest.cancel()
        }
        
        imageView.image = UIImage(systemName: "photo.on.rectangle.angled")
        priceLabel.attributedText = nil
    }
}

// MARK: - Private Actions
private extension ItemListCollectionViewCell {
    func arrangeSubView() {
        stockAndAccessoryStackView.addArrangedSubview(stockLabel)
        stockAndAccessoryStackView.addArrangedSubview(accessaryImageView)
        
        firstRowHorizontalStackView.addArrangedSubview(nameLabel)
        firstRowHorizontalStackView.addArrangedSubview(stockAndAccessoryStackView)
        
        secondRowHorizontalStackView.addArrangedSubview(priceLabel)
        secondRowHorizontalStackView.addArrangedSubview(bargainPriceLabel)
        
        informationLabelsStackView.addArrangedSubview(firstRowHorizontalStackView)
        informationLabelsStackView.addArrangedSubview(secondRowHorizontalStackView)
        
        entireHorizontalStackView.addArrangedSubview(imageView)
        entireHorizontalStackView.addArrangedSubview(informationLabelsStackView)
        
        contentView.addSubview(entireHorizontalStackView)
    }
    
    func setupUIComponentsLayout() {
        setupEntireStackViewLayout()
        setupImageViewLayout()
        setupAccessaryImageViewLayout()
    }
    
    func setupEntireStackViewLayout() {
        NSLayoutConstraint.activate([
            entireHorizontalStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            entireHorizontalStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
            entireHorizontalStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -10
            ),
            entireHorizontalStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 5
            )
        ])
    }
    
    func setupImageViewLayout() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(
                equalTo: contentView.heightAnchor,
                multiplier: 0.8
            ),
            imageView.widthAnchor.constraint(
                equalTo: imageView.heightAnchor
            )
        ])
    }
    
    func setupAccessaryImageViewLayout() {
        accessaryImageView.widthAnchor.constraint(
            equalTo: contentView.heightAnchor,
            multiplier: 0.1
        ).isActive = true
    }
}
