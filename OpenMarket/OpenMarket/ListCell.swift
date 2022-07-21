//
//  CollectionViewListLayoutCell.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/15.
//

import UIKit

final class ListCell: UICollectionViewCell {
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.alignment = .fill
        stackview.distribution = .fillEqually
        return stackview
    }()
    
    private let upperHorizontalStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.alignment = .fill
        stackview.distribution = .equalSpacing
        return stackview
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        label.text = "Mac mini"
        return label
    }()
    
    private let lowerHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private let productBargainPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = "JPY 300"
        label.sizeToFit()
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "JPY 800"
        return label
    }()
    
    private lazy var indicatorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .lightGray
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAddSubviews()
        setupConstraints()
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAddSubviews() {
        self.contentView.addSubview(productImageView)
        self.contentView.addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(upperHorizontalStackView)
        verticalStackView.addArrangedSubview(lowerHorizontalStackView)
        
        upperHorizontalStackView.addArrangedSubview(productNameLabel)
        upperHorizontalStackView.addArrangedSubview(indicatorLabel)
        
        lowerHorizontalStackView.addArrangedSubview(productPriceLabel)
        lowerHorizontalStackView.addArrangedSubview(productBargainPriceLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            productImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            productImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            productImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -10),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            verticalStackView.topAnchor.constraint(equalTo: productImageView.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupLayer() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
    }
    
    func setup(with inputData: Product) {
        guard let url = URL(string: inputData.thumbnail) else {
            return
        }
        self.productImageView.loadImage(url: url)
        self.productNameLabel.text = inputData.name
        setupPriceLabel(currency: inputData.currency,
                        price: inputData.price,
                        bargainPrice: inputData.bargainPrice
        )
        setupIndicatorLabelData(stock: inputData.stock)
        self.productImageView.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
    }
    
    private func setupPriceLabel(currency: Currency, price: Int, bargainPrice: Int) {
        let upperCurreny = currency.rawValue.uppercased()
        if price == bargainPrice {
            let price = price.adoptDecimalStyle()
            self.productBargainPriceLabel.isHidden = true
            self.productPriceLabel.text = "\(upperCurreny) " + price
        } else {
            let price = price.adoptDecimalStyle()
            let bargainPrice = bargainPrice.adoptDecimalStyle()
            self.productPriceLabel.strikethrough(from: "\(upperCurreny) " + price)
            self.productBargainPriceLabel.text = " \(upperCurreny) " + bargainPrice
            self.productPriceLabel.textColor = .red
        }
    }
    
    private func setupIndicatorLabelData(stock: Int) {
        let attriubutedString: NSMutableAttributedString
        if stock > 0 {
            attriubutedString = NSMutableAttributedString(string: "잔여수량 : \(stock) ")
            self.indicatorLabel.textColor = .lightGray
        } else {
            attriubutedString = NSMutableAttributedString(string: "품절 ")
            self.indicatorLabel.textColor = .orange
        }
        let chevronAttachment = NSTextAttachment()
        let chevronImage = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 13,weight: .semibold))?.withTintColor(.lightGray)
        chevronAttachment.image = chevronImage
        let imageWidth = chevronImage?.size.width ?? 0
        let imageHeight = chevronImage?.size.height ?? 0
        chevronAttachment.bounds = CGRect(x: 0, y: -1, width: imageWidth,  height: imageHeight)
        attriubutedString.append(NSAttributedString(attachment: chevronAttachment))
        
        self.indicatorLabel.attributedText = attriubutedString
    }
    
    override func prepareForReuse() {
        self.indicatorLabel.textColor = nil
        self.productImageView.image = nil
        self.productPriceLabel.textColor = .lightGray
        self.productPriceLabel.attributedText = nil
        self.productBargainPriceLabel.isHidden = false
    }
}
