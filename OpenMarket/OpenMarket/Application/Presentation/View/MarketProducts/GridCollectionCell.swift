//
//  GridCollectionCell.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍. 
//

import UIKit

final class GridCollectionCell: UICollectionViewCell {
    // MARK: Properties
    
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        label.numberOfLines = 0

        return label
    }()
    
    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        label.numberOfLines = 0

        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        
        return label
    }()
    
    private var viewModel: MarketProductsViewModel?
    
    // MARK: - Cell Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureGridCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productImageView.image = nil
        productNameLabel.text = nil
        originalPriceLabel.text = nil
        originalPriceLabel.textColor = .systemGray
        discountedPriceLabel.text = nil
        discountedPriceLabel.textColor = .systemGray
        stockLabel.text = nil
        stockLabel.textColor = .systemGray
    }
    
    // MARK: - UI
    
    private func configureGridCell() {
        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubview(productImageView)
        rootStackView.addArrangedSubview(labelStackView)
        
        labelStackView.addArrangedSubview(productNameLabel)
        labelStackView.addArrangedSubview(originalPriceLabel)
        labelStackView.addArrangedSubview(discountedPriceLabel)
        labelStackView.addArrangedSubview(stockLabel)

        let inset = CGFloat(10)
            
        NSLayoutConstraint.activate([
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
    }
    
    private func configureForOriginal() {
        discountedPriceLabel.isHidden = true
        originalPriceLabel.attributedText = originalPriceLabel.text?.strikeThrough(value: 0)
        originalPriceLabel.textColor = .systemGray
    }
    
    private func configureForBargain() {
        discountedPriceLabel.isHidden = false
        originalPriceLabel.attributedText = originalPriceLabel.text?.strikeThrough(value: NSUnderlineStyle.single.rawValue)
        originalPriceLabel.textColor = .systemRed
    }
    
    func updateUI(_ data: ProductEntity) {
        viewModel =  MarketProductsViewModel(product: data)
        productImageView.image = viewModel?.thumbnailImage
        productNameLabel.text = viewModel?.name
        originalPriceLabel.text = viewModel?.originalPriceText
        discountedPriceLabel.text =  viewModel?.discountedPriceText
        stockLabel.text = viewModel?.stockText
        
        viewModel?.isDiscountedItem == true ? self.configureForBargain() : self.configureForOriginal()
        stockLabel.textColor = viewModel?.isEmptyStock == true ? .systemYellow : .systemGray
    }
}
