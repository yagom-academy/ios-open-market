//
//  ItemGridCell.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/09/11.
//

import UIKit

class ItemGridCell: UICollectionViewCell {
    static let identifier = "ItemCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setUpStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let thumbnailImageView: CustomImageView = {
        guard let imageView = UIImageView(frame: .zero) as? CustomImageView else {
            return CustomImageView()
        }
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()

    let discountedPriceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()

    let stockLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
}

extension ItemGridCell {
    func setup(with item: Item) {
        if let url = URL(string: item.thumbnailURLs[0]) {
            thumbnailImageView.loadImage(from: url)
        }
        contentView.addSubview(stockLabel)
        titleLabel.text = item.title
        discountedPriceLabel.text = "\(item.currency) \(String(describing: item.discountedPrice))"
        priceLabel.text = "\(item.currency) \(item.price)"
        stockLabel.text = "잔여수량: \(item.stock)"
    }

    func addSubViews() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(discountedPriceLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(stockLabel)
        contentView.addSubview(stackView)
    }

    func setUpStackView() {
        stackView.addArrangedSubview(thumbnailImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(discountedPriceLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(stockLabel)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
            thumbnailImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor)
        ])
    }
}
