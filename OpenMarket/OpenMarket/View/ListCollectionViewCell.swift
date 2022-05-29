//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/16.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    static let identifier = "CollectionViewCell"
    private var productImage: UIImageView = UIImageView()
    private var productName: UILabel = UILabel()
    private var originalPrice = UILabel()
    private var discountedPrice = UILabel()
    private var stock: UILabel = UILabel()
    
    private lazy var priceStackView = makeStackView(axis: .horizontal, alignment: .leading, distribution: .fillEqually, spacing: 5)
    private lazy var productStackView = makeStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 5)
    private lazy var entireProductStackView = makeStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 5)
    private lazy var accessoryStackView = makeStackView(axis: .horizontal, alignment: .top, distribution: .fill, spacing: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.layer.addSeparator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        discountedPrice.isHidden = false
        originalPrice.attributedText = nil
        
        accessoryStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    func configureCell(_ presenter: Presenter) {
        configureCellUI(presenter)
        configurePriceUI(presenter)
        configureProductUI(presenter)
        configureAccessoryUI(presenter)
        configureEntireProductUI()
    }
}

// MARK: - setup UI
extension ListCollectionViewCell {
    private func configureCellUI(_ presenter: Presenter) {
        productName.text = presenter.productName
        
        guard let imageUrl = presenter.productImage else {
            return
        }
        
        productImage.loadImage(imageUrl)
    }
    
    private func configurePriceUI(_ presenter: Presenter) {
        originalPrice.text = presenter.price
        discountedPrice.text = presenter.bargainPrice
        
        if presenter.price == presenter.bargainPrice {
            originalPrice.textColor = .systemGray2
            discountedPrice.isHidden = true
        } else {
            originalPrice.attributedText = originalPrice.text?.strikeThrough()
            originalPrice.textColor = .systemRed
            discountedPrice.textColor = .systemGray2
        }
        
        priceStackView.addArrangedSubview([originalPrice, discountedPrice])
    }
    
    private func configureProductUI(_ presenter: Presenter) {
        productName.font = UIFont.preferredFont(forTextStyle: .title3)
        
        productStackView.addArrangedSubview([productName, priceStackView])
    }
    
    private func configureAccessoryUI(_ presenter: Presenter) {
        let button = UIButton()
                
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        button.tintColor = .systemGray2
        
        stock.text = presenter.stock
        
        if presenter.stock != "품절" {
            stock.textColor = .systemGray2
        } else {
            stock.textColor = .systemYellow
        }
        
        stock.textAlignment = .right
        accessoryStackView.addArrangedSubview([stock, button])
    }
    
    private func configureEntireProductUI() {
        entireProductStackView.addArrangedSubview([productImage, productStackView, accessoryStackView])
        self.contentView.addSubview(entireProductStackView)
        
        NSLayoutConstraint.activate([
            productImage.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.15),
            entireProductStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            entireProductStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            entireProductStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            entireProductStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ])
    }
}

// MARK: - support UI
extension ListCollectionViewCell {
    private func makeStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        
        return stackView
    }
    
    private func strikeThrough(price: UILabel) {
        originalPrice.textColor = .systemRed
        originalPrice.attributedText = originalPrice.text?.strikeThrough()
    }
}
