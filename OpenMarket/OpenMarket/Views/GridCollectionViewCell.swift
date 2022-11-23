//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by 스톤, 로빈 on 2022/11/22.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell {
    override var reuseIdentifier: String {
        return String(describing: Self.self)
    }

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()

    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 2
        return stackView
    }()

    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    private let bargainPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = " "
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureUI()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(item: Item) {
        if let url = URL(string: item.thumbnail) {
            NetworkManager().fetchImage(url: url) { image in
                DispatchQueue.main.async {
                    self.itemImageView.image = image
                }
            }
        }
        
        self.itemNameLabel.text = item.name
        self.priceLabel.text = "\(item.currency.rawValue) \(item.price)"
        self.priceLabel.textColor = .systemGray
    
        if item.bargainPrice != 0 {
            self.priceLabel.textColor = .systemRed
            self.priceLabel.attributedText = self.priceLabel.text?.strikeThrough()
            self.bargainPrice.text = "\(item.currency.rawValue) \(item.bargainPrice)"
            self.bargainPrice.textColor = .systemGray
        }
        
        if item.stock == 0 {
            self.stockLabel.textColor = .systemOrange
            self.stockLabel.text = "품절"
        } else {
            self.stockLabel.textColor = .systemGray
            self.stockLabel.text = "잔여수량 : \(item.stock)"
        }
        
    }
    private func configureUI() {
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        
    }
    private func configureView() {
        self.contentView.addSubview(self.itemImageView)
        self.contentView.addSubview(stackView)
        self.priceStackView.addArrangedSubview(priceLabel)
        self.priceStackView.addArrangedSubview(bargainPrice)
        self.stackView.addArrangedSubview(self.itemNameLabel)
        self.stackView.addArrangedSubview(self.priceStackView)
        self.stackView.addArrangedSubview(self.stockLabel)
    }

    private func configureConstraints() {
        let inset = CGFloat(5)

        NSLayoutConstraint.activate([
            self.itemImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.5),
            self.itemImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: inset),
            self.itemImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: inset),
            self.itemImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -inset),

            self.stackView.topAnchor.constraint(equalTo: self.itemImageView.bottomAnchor, constant: inset),
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: inset),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -inset),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -inset),

        ])
    }
}
