//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/19.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var stock: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discountedPrice: UILabel!
    
    override func prepareForReuse() {
        
    }
    
    func updateGridCell(data: ProductList, indexPathItem: Int) {
        guard let imageURL = URL(string: "\(data.productsInPage[indexPathItem].thumbnail)") else {
            return
        }
        let imageData = try? Data(contentsOf: imageURL)

        
        thumbnail.image = UIImage(data: imageData ?? Data())
        name.text = data.productsInPage[indexPathItem].name
        stock.text = "\(data.productsInPage[indexPathItem].stock)"
        price.text = "\(data.productsInPage[indexPathItem].currency) \(data.productsInPage[indexPathItem].price)"
        discountedPrice.text = "\(data.productsInPage[indexPathItem].currency) \(data.productsInPage[indexPathItem].discountedPrice)"
   
        
        NSLayoutConstraint.activate([
            thumbnail.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            thumbnail.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            thumbnail.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            thumbnail.trailingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 50),
            
            name.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            name.bottomAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            name.leadingAnchor.constraint(equalTo: self.thumbnail.trailingAnchor),
            name.trailingAnchor.constraint(equalTo: self.stock.leadingAnchor),
            
            
            stock.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            stock.bottomAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            stock.leadingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -100),
            stock.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            price.topAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            price.bottomAnchor.constraint(equalTo: self.contentView
                                            .bottomAnchor),
            price.leadingAnchor.constraint(equalTo: self.thumbnail.trailingAnchor),
            price.trailingAnchor.constraint(equalTo: self.thumbnail.trailingAnchor, constant: 50),
            
            discountedPrice.centerYAnchor.constraint(equalTo: self.price.centerYAnchor),
            discountedPrice.heightAnchor.constraint(equalTo: self.price.heightAnchor),
            discountedPrice.leadingAnchor.constraint(equalTo: self.price.trailingAnchor),
            discountedPrice.trailingAnchor.constraint(equalTo: self.stock.leadingAnchor)
        ])
        
        
    }
    
    func updateListCell(data: ProductList, indexPathItem: Int) {
        guard let imageURL = URL(string: "\(data.productsInPage[indexPathItem].thumbnail)") else {
            return
        }
        let imageData = try? Data(contentsOf: imageURL)
        
        thumbnail.image = UIImage(data: imageData ?? Data())
        name.text = data.productsInPage[indexPathItem].name
        stock.text = "\(data.productsInPage[indexPathItem].stock)"
        price.text = "\(data.productsInPage[indexPathItem].currency) \(data.productsInPage[indexPathItem].price)"
        discountedPrice.text = "\(data.productsInPage[indexPathItem].currency) \(data.productsInPage[indexPathItem].discountedPrice)"
   
        
        NSLayoutConstraint.activate([
            thumbnail.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            thumbnail.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            thumbnail.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            thumbnail.trailingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 50),
            
            name.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            name.bottomAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            name.leadingAnchor.constraint(equalTo: self.thumbnail.trailingAnchor),
            name.trailingAnchor.constraint(equalTo: self.stock.leadingAnchor),
            
            
            stock.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            stock.bottomAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            stock.leadingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -100),
            stock.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            price.topAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            price.bottomAnchor.constraint(equalTo: self.contentView
                                            .bottomAnchor),
            price.leadingAnchor.constraint(equalTo: self.thumbnail.trailingAnchor),
            price.trailingAnchor.constraint(equalTo: self.thumbnail.trailingAnchor, constant: 50),
            
            discountedPrice.centerYAnchor.constraint(equalTo: self.price.centerYAnchor),
            discountedPrice.heightAnchor.constraint(equalTo: self.price.heightAnchor),
            discountedPrice.leadingAnchor.constraint(equalTo: self.price.trailingAnchor),
            discountedPrice.trailingAnchor.constraint(equalTo: self.stock.leadingAnchor)
        ])
        
    }
    
}
