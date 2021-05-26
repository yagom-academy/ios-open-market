//
//  ItemListCell.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/21.
//

import UIKit

class ItemListCell: UICollectionViewCell {
    static let reuseIdentifier = "itemListCell"

    private var fetchImageDataTask: URLSessionDataTask?

    private let imageView = ItemCellImageView(systemName: "photo")
    private let titleLabel = ItemCellLabel(textStyle: .headline)
    private let priceLabel = PriceLabel(textColor: .lightGray)
    private let discountedPriceLabel = ItemCellLabel(textColor: .lightGray)

    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()

    private let disclosureIndicatorImageView = ItemCellImageView(systemName: "chevron.forward")
    private let stockLabel = StockLabel(textColor: .lightGray)

    private let divisionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        return view
    }()

    var item: MarketPage.Item? {
        didSet {
            fetchImageDataTask = SessionManager.shared.fetchImageDataTask(urlString: item?.thumbnails.first) { data in
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            fetchImageDataTask?.resume()

            titleLabel.text = item?.title

            if let currency = item?.currency,
               let price = item?.price {
                if let discountedPrice = item?.discountedPrice {
                    priceLabel.setText(by: .discounted, currency, price)
                    discountedPriceLabel.text = "\(currency) \(discountedPrice)"
                } else {
                    priceLabel.setText(by: .normal, currency, price)
                }
            }

            if let stock = item?.stock {
                stockLabel.setText(stock)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        fetchImageDataTask?.cancel()
        imageView.reset()
        titleLabel.reset()
        priceLabel.reset()
        discountedPriceLabel.reset()
        stockLabel.reset()
    }

    func addSubviews() {
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(discountedPriceLabel)

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(priceStackView)
        addSubview(disclosureIndicatorImageView)
        addSubview(stockLabel)
        addSubview(divisionLine)
    }

    func activateConstraints() {
        var constraints = [NSLayoutConstraint]()

        titleLabel.setContentCompressionResistancePriority(.defaultHigh - 1, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        priceLabel.setContentCompressionResistancePriority(.defaultHigh - 1, for: .horizontal)

        let imageViewConstraints = [
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]

        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: stockLabel.leadingAnchor, constant: -5)
        ]

        let priceStackViewConstraints = [
            priceStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            priceStackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -10)
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

        constraints.append(contentsOf: imageViewConstraints)
        constraints.append(contentsOf: titleLabelConstraints)
        constraints.append(contentsOf: priceStackViewConstraints)
        constraints.append(contentsOf: disclosureIndicatorImageViewContraints)
        constraints.append(contentsOf: stockLabelConstraints)
        constraints.append(contentsOf: divisionLineCosntraints)

        NSLayoutConstraint.activate(constraints)
    }
}
