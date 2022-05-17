//
//  CollectionViewGridCell.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/16.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private lazy var productImage: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var productTitle: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var productPrice: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var discountPrice: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var stock: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [productImage, productTitle, productPrice, discountPrice, stock])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.distribution = .fill
        view.axis = .vertical
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 5
        setCellView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCellView() {
        contentView.addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            productImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            productImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
        ])
    }
    
    func configureContent(productInformation product: ProductInformation) {        
        productImage.image = product.thumbnailImage
        productTitle.text = product.name
        productPrice.text = "\( product.currency) \(product.price)"
        discountPrice.text = "\(product.discountedPrice)"
        if product.stock == 0 {
            stock.text = "품절"
            stock.textColor = .yellow
        } else {
            stock.text = "판매수량: \(product.stock)"
            stock.textColor = .black
        }
    }
}
