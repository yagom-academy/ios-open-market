//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/18.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell {
    static let identifier = "GridCollectionViewCell"
    private var productImage: UIImageView = UIImageView()
    private var productName: UILabel = UILabel()
    private var originalPrice = UILabel()
    private var discountedPrice = UILabel()
    private var stock: UILabel = UILabel()

    private lazy var productStackView = makeStackView(axis: .vertical, alignment: .center, distribution: .equalSpacing, spacing: 5)
    private lazy var priceStackView = makeStackView(axis: .vertical, alignment: .center, distribution: .fill, spacing: 3)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeSeparator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        discountedPrice.isHidden = false
        originalPrice.attributedText = nil
    }
    
    func configureCell(_ presenter: Presenter) {
        setPriceUI(presenter)
        setCellUI(presenter)
        configureProductUI()
    }
}

// MARK: - setup UI
extension GridCollectionViewCell {
    private func setPriceUI(_ presenter: Presenter) {
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
    
    private func setCellUI(_ presenter: Presenter) {
        productName.text = presenter.productName
        productName.font = UIFont.boldSystemFont(ofSize: 20)
        stock.text = presenter.stock
        
        if presenter.stock != "품절" {
            stock.textColor = .systemGray2
        } else {
            stock.textColor = .systemYellow
        }
        
        guard let imageUrl = presenter.productImage else {
            return
        }
        
        productImage.loadImage(imageUrl)
    }
    
    private func configureProductUI() {
        productStackView.addArrangedSubview([productImage, productName, priceStackView, stock])
        self.contentView.addSubview(productStackView)
        
        NSLayoutConstraint.activate([
            productStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            productStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            productStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            productStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            productImage.widthAnchor.constraint(equalToConstant: 100),
            productImage.heightAnchor.constraint(equalTo: productImage.widthAnchor)
        ])
    }
}

// MARK: - support UI
extension GridCollectionViewCell {
    private func makeStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        
        return stackView
    }
    
    private func makeSeparator() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.cornerRadius = 10
    }
    
    private func strikeThrough(price: UILabel) {
        originalPrice.textColor = .systemRed
        originalPrice.attributedText = originalPrice.text?.strikeThrough()
    }
}
