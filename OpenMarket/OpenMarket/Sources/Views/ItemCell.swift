//
//  ItemCell.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/21.
//

import UIKit

class ItemCell: UICollectionViewCell {
    static let reuseIdentifier = "itemCell"
    private var currentConstraints = [NSLayoutConstraint]()

    private let imageView = ItemCellImageView(systemName: "photo")
    private let titleLabel = ItemCellLabel(textStyle: .headline)
    private let priceLabel = ItemCellLabel(textColor: .lightGray)
    private let discountedPriceLabel = ItemCellLabel(textColor: .lightGray)

    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(discountedPriceLabel)
        return stackView
    }()

    private let disclosureIndicatorImageView = ItemCellImageView(systemName: "chevron.forward")
    private let stockLabel = ItemCellLabel(textColor: .lightGray)

    private let divisionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        return view
    }()

    var item: Page.Item? {
        didSet {
            DispatchQueue.main.async {
                guard let thumnailURL = self.item?.thumbnails[0],
                      let url = URL(string: thumnailURL),
                      let data = try? Data(contentsOf: url),
                      let image = UIImage(data: data) else { return }
                self.imageView.image = image
            }

            titleLabel.text = item?.title

            if let currency = item?.currency,
               let price = item?.price {
                priceLabel.text = "\(currency) \(price)"
                if let discountedPrice = item?.discountedPrice {
                    priceLabel.attributedText = NSAttributedString(string: "\(currency) \(price)",
                                                                   attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
                    priceLabel.textColor = .systemRed
                    discountedPriceLabel.text = "\(currency) \(discountedPrice)"
                }
            }

            if let stock = item?.stock {
                if stock > 0 {
                    stockLabel.text = "잔여수량 : \(stock)"
                } else {
                    stockLabel.text = "품절"
                    stockLabel.textColor = .systemOrange
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        layer.cornerRadius = 20
        layer.borderColor = UIColor.systemGray3.cgColor

        switch LayoutMode.current {
        case .list:
            activateListConstraints()
        case .grid:
            activateGridConstraints()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        imageView.image = UIImage(systemName: "photo")
        titleLabel.reset()
        priceLabel.reset()
        discountedPriceLabel.reset()
        stockLabel.reset()

        switch LayoutMode.current {
        case .list:
            activateListConstraints()
            disclosureIndicatorImageView.isHidden = false
            priceStackView.axis = .horizontal
            layer.borderWidth = 0
        case .grid:
            activateGridConstraints()
            disclosureIndicatorImageView.isHidden = true
            priceStackView.axis = .vertical
            layer.borderWidth = 1
        }
    }

    func addSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(priceStackView)
        addSubview(disclosureIndicatorImageView)
        addSubview(stockLabel)
        addSubview(divisionLine)
    }

    func activateListConstraints() {
        NSLayoutConstraint.deactivate(currentConstraints)
        currentConstraints.removeAll()

        let imageViewConstraints = [
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]

        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        ]

        let priceStackViewConstraints = [
            priceStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        ]

        let disclosureIndicatorImageViewContraints = [
            disclosureIndicatorImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            disclosureIndicatorImageView.topAnchor.constraint(equalTo: titleLabel.topAnchor)
        ]

        let stockLabelConstraints = [
            stockLabel.trailingAnchor.constraint(equalTo: disclosureIndicatorImageView.leadingAnchor, constant: -10),
            stockLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor)
        ]

        let divisionLineCosntraints = [
            divisionLine.heightAnchor.constraint(equalToConstant: 1),
            divisionLine.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            divisionLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            divisionLine.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]

        currentConstraints.append(contentsOf: imageViewConstraints)
        currentConstraints.append(contentsOf: titleLabelConstraints)
        currentConstraints.append(contentsOf: priceStackViewConstraints)
        currentConstraints.append(contentsOf: disclosureIndicatorImageViewContraints)
        currentConstraints.append(contentsOf: stockLabelConstraints)
        currentConstraints.append(contentsOf: divisionLineCosntraints)

        NSLayoutConstraint.activate(currentConstraints)
    }

    func activateGridConstraints() {
        NSLayoutConstraint.deactivate(currentConstraints)
        currentConstraints.removeAll()

        let imageViewConstraints = [
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        ]

        let titleLabelConstraints = [
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        ]

        titleLabel.setContentHuggingPriority(.required, for: .vertical)

        let priceStackViewConstraints = [
            priceStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            priceStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        ]

        let stockLabelConstraints = [
            stockLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stockLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ]

        stockLabel.setContentHuggingPriority(.required, for: .vertical)

        currentConstraints.append(contentsOf: imageViewConstraints)
        currentConstraints.append(contentsOf: titleLabelConstraints)
        currentConstraints.append(contentsOf: priceStackViewConstraints)
        currentConstraints.append(contentsOf: stockLabelConstraints)

        NSLayoutConstraint.activate(currentConstraints)
    }
}
