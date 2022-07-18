//
//  CollectionViewListLayoutCell.swift
//  OpenMarket
//
//  Created by 이원빈 on 2022/07/15.
//

import UIKit

class ListCell: UICollectionViewCell {
    
    let numberFormatter = NumberFormatter()
    
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
        stackview.distribution = .fill
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
        stackView.distribution = .fill
        stackView.alignment = .fill
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
        numberFormatter.numberStyle = .decimal
        setupAddSubviews()
        setupConstraints()
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
//            productImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.2),
//            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor)
            productImageView.widthAnchor.constraint(equalToConstant: 50),
            productImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            verticalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            verticalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            verticalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10)
        ])
    }
    
    func setupCellData(with inputData: Product) {
        guard let url = URL(string: inputData.thumbnail) else {
            return
        }
        self.productImageView.loadImage(url: url)
        self.productNameLabel.text = inputData.name
//        let price = numberFormatter.string(from: NSNumber.init(value: inputData.price))
//        self.productPriceLabel.text = "\(inputData.currency) " + (price ?? "")
        setupPriceLabel(currency: inputData.currency,
                        price: inputData.price,
                        bargainPrice: inputData.bargainPrice
        )
        setupIndicatorLabelData(stock: inputData.stock)
        self.productImageView.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
    }
    
    private func setupPriceLabel(currency: Currency, price: Int, bargainPrice: Int) {
        let upperCurreny = currency.rawValue.uppercased()
        if price == bargainPrice { // 할인 안함
            let price = numberFormatter.string(from: NSNumber.init(value: price))
            self.productBargainPriceLabel.isHidden = true
            self.productPriceLabel.text = "\(upperCurreny) " + (price ?? "")
        } else { // 할인 됨
            let price = numberFormatter.string(from: NSNumber.init(value: price))
            let bargainPrice = numberFormatter.string(from: NSNumber.init(value: bargainPrice))
            self.productPriceLabel.strikethrough(from: "\(upperCurreny) " + (price ?? "0"))
            self.productBargainPriceLabel.text = " \(upperCurreny) " + (bargainPrice ?? "0")
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

extension UIImageView {
    
    func loadImage(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            self.image = UIImage(data: data)
        } catch {
            fatalError("error")
        }
    }
}

extension UILabel {
    func strikethrough(from text: String?) {
        guard let text = text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}
