//
//  ItemListCollectionViewCell.swift
//  OpenMarket
//
//  Created by minsson, yeton on 2022/07/26.
//

import UIKit

class ItemListCollectionViewCell: UICollectionViewCell, CellConfigurable {
    
    // MARK: - UI Properties
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let accessaryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "greaterthan")
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray6
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray3
        label.textAlignment = .left
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        label.textColor = .systemGray
        return label
    }()
    
    private let firstHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let secondHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let fourthVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let thirdHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
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
        
        imageView.image = UIImage(systemName: "photo.on.rectangle.angled")
        nameLabel.text = nil
        stockLabel.text = nil
        priceLabel.text = nil
        priceLabel.attributedText = nil
    }
    
}

// MARK: - Private Actions
private extension ItemListCollectionViewCell {
    func arrangeSubView() {
        firstHorizontalStackView.addArrangedSubview(stockLabel)
        firstHorizontalStackView.addArrangedSubview(accessaryImageView)
        
        secondHorizontalStackView.addArrangedSubview(nameLabel)
        secondHorizontalStackView.addArrangedSubview(firstHorizontalStackView)
        
        thirdHorizontalStackView.addArrangedSubview(priceLabel)
        thirdHorizontalStackView.addArrangedSubview(bargainPriceLabel)
        
        fourthVerticalStackView.addArrangedSubview(secondHorizontalStackView)
        fourthVerticalStackView.addArrangedSubview(thirdHorizontalStackView)
        
        entireStackView.addArrangedSubview(imageView)
        entireStackView.addArrangedSubview(fourthVerticalStackView)
        
        contentView.addSubview(entireStackView)
    }
    
    func setupUIComponentsLayout() {
        setupEntireStackViewLayout()
        setupImageViewLayout()
        setupAccessaryImageViewLayout()
    }
    
    func setupEntireStackViewLayout() {
        NSLayoutConstraint.activate([
            entireStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            entireStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
            entireStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -10
            ),
            entireStackView.leadingAnchor.constraint(
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

