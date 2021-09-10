//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/09/03.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let cellID = "cellID"
    var imageView: UIImageView!
    var stackView: UIStackView!
    var titleLabel: UILabel!
    var priceLabel: UILabel!
    var discountedPriceLabel: UILabel!
    var stockLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        debugPrint("init Cell")
        setUpCellComponent()
        setUpConstraints()
        setUpStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpCellComponent() {
        imageView = UIImageView()
        stackView = UIStackView()
        titleLabel = UILabel()
        priceLabel = UILabel()
        discountedPriceLabel = UILabel()
        stockLabel = UILabel()

        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(discountedPriceLabel)
        stackView.addArrangedSubview(stockLabel)

        self.contentView.addSubview(imageView)
        self.contentView.addSubview(stackView)
    }

    private func setUpConstraints() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.discountedPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.stockLabel.translatesAutoresizingMaskIntoConstraints = false

        imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.6).isActive = true

        stackView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -6).isActive = true
    }

    private func setUpStyle() {
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 10.0

        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center

        titleLabel.adjustsFontSizeToFitWidth = true
        priceLabel.adjustsFontSizeToFitWidth = true
        discountedPriceLabel.adjustsFontSizeToFitWidth = true
        stockLabel.adjustsFontSizeToFitWidth = true

        priceLabel.textColor = .gray
        discountedPriceLabel.textColor = .gray
        stockLabel.textColor = .gray
    }

    func configureCell(item: Item) {
        priceLabel.backgroundColor = .blue
        discountedPriceLabel.backgroundColor = .green

        item.image { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }

        titleLabel.text = item.title
        let priceWithCurrency = item.currency + " " + item.price.withDigit

        if let discountedPrice = item.discountedPrice {
            priceLabel.attributedText = priceWithCurrency.strikeThrough()
            priceLabel.textColor = .red
            discountedPriceLabel.text = item.currency + " " + discountedPrice.withDigit
        } else {
            priceLabel.text = priceWithCurrency
        }

        if item.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .orange
        } else {
            stockLabel.text = "잔여수량 : \(item.stock.withDigit)"
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = .none
        priceLabel.textColor = .gray
        priceLabel.attributedText = nil
        discountedPriceLabel.text = .none
        stockLabel.textColor = .gray
    }
}

extension String {
    func strikeThrough() -> NSAttributedString {
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
            return attributeString
        }
}

extension Int {
    var withDigit: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(for: self) ?? ""
        return result
    }
}
