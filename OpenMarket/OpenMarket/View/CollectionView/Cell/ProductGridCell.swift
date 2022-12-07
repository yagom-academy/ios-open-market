//
//  ProductGridCell.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/22.
//

import UIKit

final class ProductGridCell: UICollectionViewCell {
    //MARK: - Views
    private let thumbnailImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .title3,
                                          compatibleWith: UITraitCollection.init(preferredContentSizeCategory: .large))
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let stockLabel: StockLabel = StockLabel()
    private let priceLabel: PriceLabel = PriceLabel()
    private let stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private var product: Product? {
        didSet {
            setUpDataIfNeeded()
        }
    }
    private var imageParser: ImageParser = ImageParser()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Method
    func updateWithProduct(_ newProduct: Product) {
        self.product = newProduct
    }
    
    private func configure() {
        setUpLayer()
        setUpTextAlignment()
        setUpViewsIfNeeded()
    }
    
    private func setUpLayer() {
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.gray.cgColor
    }
    
    private func setUpTextAlignment() {
        nameLabel.textAlignment = .center
        priceLabel.textAlignment = .center
        stockLabel.textAlignment = .center
    }
    private func setUpViewsIfNeeded() {
        let spacing: CGFloat = 10
        stackView.addArrangedSubview(thumbnailImageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(stockLabel)
        contentView.addSubview(stackView)
        
        let imageViewConstraints: (width: NSLayoutConstraint,
                                   height: NSLayoutConstraint)  =
        (width: thumbnailImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
         height: thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor))
        imageViewConstraints.width.priority = .init(rawValue: 1000)
        imageViewConstraints.height.priority = .init(rawValue: 751)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: spacing),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                              constant: -spacing),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: spacing),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -spacing),
            imageViewConstraints.width, imageViewConstraints.height
        ])
    }
    
    private func setUpDataIfNeeded() {
        guard let product: Product = product,
              let bargainPrice: Double = product.bargainPrice else {
            return
        }
        
        nameLabel.text = product.name
        stockLabel.stock = product.stock
        priceLabel.setPrice(product.price,
                            bargainPrice: bargainPrice,
                            currency: product.currency,
                            style: .grid)
    }
    
    func setUpImage(from thumbnail: String?) {
        imageParser.parse(thumbnail) { [weak self] (thumbnailImage) in
            if self?.product?.thumbnail == thumbnail {
                self?.thumbnailImageView.image = thumbnailImage
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageParser.cancelTask()
        thumbnailImageView.image = nil
        nameLabel.text = ""
        stockLabel.stock = 0
        priceLabel.setPrice(0,
                            bargainPrice: 0,
                            currency: Currency.krw,
                            style: .grid)
    }
}
