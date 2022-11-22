//
//  ListCell.swift
//  OpenMarket
//
//  Created by 이정민 on 2022/11/22.
//

import UIKit

class ListCell: UICollectionViewListCell {
    var image: UIImage? {
        guard let url = URL(string: imageURL) else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        return UIImage(data: data)
    }
    let imageURL: String
    let productName: String
    let price: Double
    let bargainPrice: Double
    var discountedPrice: Double {
        return price - bargainPrice
    }
    let stock: Int
    
    init(_ item: Product) {
        self.imageURL = item.thumbnail
        self.productName = item.name
        self.price = item.price
        self.bargainPrice = item.bargainPrice
        self.stock = item.stock
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
