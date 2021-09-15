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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let discountedPriceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let stockLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    
    let priceStackView: UIStackView = {
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
        contentView.addSubview(contentStackView)
        contentView.addSubview(priceStackView)
    }

    func setUpStackView() {
        contentStackView.addArrangedSubview(thumbnailImageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(priceStackView)
        contentStackView.addArrangedSubview(stockLabel)
        
        priceStackView.addArrangedSubview(discountedPriceLabel)
        priceStackView.addArrangedSubview(priceLabel)

        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
            contentStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            thumbnailImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor)
        ])
    }
    
    func setUpCellBorder(cell: ItemGridCell) {
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
    }
}
