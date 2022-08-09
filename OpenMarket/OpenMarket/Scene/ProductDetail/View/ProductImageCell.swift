//
//  ProductImageCell.swift
//  OpenMarket
//
//  Created by 김동용 on 2022/08/09.
//

import UIKit

final class ProductImageCell: UICollectionViewCell {
    // MARK: - properties
    
    static let identifier = "ImageCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    // MARK: - initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
