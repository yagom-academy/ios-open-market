//
//  CollectionViewListCell.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/16.
//

import UIKit

@available(iOS 14.0, *)
final class ListCollectionViewCell: UICollectionViewListCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private func defaultListConfiguration() -> UIListContentConfiguration {
        return .subtitleCell()
    }
    
    private lazy var listContentView = UIListContentView(configuration: .subtitleCell())
    
    private let stock = UILabel()
    
    func setConstrait() {
        [listContentView, stock].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            stock.leadingAnchor.constraint(greaterThanOrEqualTo: listContentView.leadingAnchor),
            stock.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            listContentView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    
    func configureContent(productInformation product: ProductInformation) {
        
        var configure = defaultListConfiguration()
        
        configure.image = product.thumbnailImage
        configure.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        configure.text = product.name
        configure.textProperties.font = .preferredFont(forTextStyle: .headline)
        
        if product.discountedPrice == 0 {
            configure.secondaryText = "\(product.currency) \(product.price)"
        } else {
            configure.secondaryText = "\(product.discountedPrice) \(product.currency) \(product.discountedPrice) \(product.price) "
            //일부글자 폰트 바꾸도록 설정
        }
        
        listContentView.configuration = configure

        if product.stock == 0 {
            stock.text = "품절"
            stock.textColor = .yellow
        } else {
            stock.text = "잔여수량: \(product.stock)"
            stock.textColor = .black
        }
        setConstrait()
    }
}
