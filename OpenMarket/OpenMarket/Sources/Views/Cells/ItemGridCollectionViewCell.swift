//
//  ItemGridCollectionViewCell.swift
//  OpenMarket
//
//  Created by minsson, yeton on 2022/08/03.
//

import UIKit

final class ItemGridCollectionViewCell: UICollectionViewCell, CellConfigurable {
    
    // MARK: - Properties
    
    var imageRequest: URLSessionTask?
    
    // MARK: - UI Properties
    
    private let entireVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.bargainPriceLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Color.priceLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.stockLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        arrangeSubView()
        setupUIComponentsLayout()
        setupLayerAttributes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageRequest?.cancel()
        
        imageView.image = UIImage(systemName: "photo.on.rectangle.angled")
        priceLabel.attributedText = nil
    }
}

// MARK: - Private Actions

private extension ItemGridCollectionViewCell {
    func arrangeSubView() {
        entireVerticalStackView.addArrangedSubview(imageView)
        entireVerticalStackView.addArrangedSubview(nameLabel)
        entireVerticalStackView.addArrangedSubview(priceLabel)
        entireVerticalStackView.addArrangedSubview(bargainPriceLabel)
        entireVerticalStackView.addArrangedSubview(stockLabel)
        
        contentView.addSubview(entireVerticalStackView)
    }
    
    func setupLayerAttributes() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    func setupUIComponentsLayout() {
        setupVerticalStackViewLayout()
        setupImageViewLayout()
    }
    
    func setupVerticalStackViewLayout() {
        NSLayoutConstraint.activate([
            entireVerticalStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8
            ),
            entireVerticalStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -8
            ),
            entireVerticalStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -10
            ),
            entireVerticalStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 10
            )
        ])
    }
    
    func setupImageViewLayout() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(
                equalTo: contentView.heightAnchor,
                multiplier: 0.5
            ),
            imageView.widthAnchor.constraint(
                equalTo: imageView.heightAnchor,
                multiplier: 0.9
            )
        ])
    }
}
