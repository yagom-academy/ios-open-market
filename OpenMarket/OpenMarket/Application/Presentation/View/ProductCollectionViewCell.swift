//
//  ProductCollectionViewCell.swift
//  OpenMarket
//
//  Created by Derrick kim on 2022/07/12.
//

import UIKit

final class ProductCollectionViewCell: UICollectionViewListCell {
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "mini")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondaryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    private let originPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        titleLabel.text = nil
        originPriceLabel.text = nil
        bargainPriceLabel.text = nil
    }
    
    func addSubView() {
        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubview(imageView)
        rootStackView.addArrangedSubview(labelStackView)
        rootStackView.addArrangedSubview(secondaryStackView)
        
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(secondaryStackView)
        
        secondaryStackView.addArrangedSubview(originPriceLabel)
        secondaryStackView.addArrangedSubview(bargainPriceLabel)
        rootStackView.addArrangedSubview(stockLabel)
        
        NSLayoutConstraint.activate([
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stockLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 50)
        ])
    }
    
    func configureStackView(of axis: NSLayoutConstraint.Axis, textAlignment: NSTextAlignment) {
        rootStackView.axis = axis
        secondaryStackView.axis = axis
        titleLabel.textAlignment = textAlignment
        originPriceLabel.textAlignment = textAlignment
        bargainPriceLabel.textAlignment = textAlignment
        stockLabel.textAlignment = axis == .horizontal ? .right : .center
        
        if axis == .horizontal {
            secondaryStackView.alignment = .fill
        }
    }
    
    func configure(_ data: ProductEntity) {
        imageView.image = data.thumbnailImage
        titleLabel.text = data.name
        originPriceLabel.text = data.originalPrice.description
        bargainPriceLabel.text = data.discountedPrice.description
        stockLabel.text = data.stock.description == "0" ? "품절" : data.stock.description
    }
}
