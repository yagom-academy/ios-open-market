//
//  EditViewCell.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/29.
//

import UIKit

final class EditViewCell: UICollectionViewCell {
    static let identifier = "EditViewCell"
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        makeProductImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        makeProductImage()
    }
    
    func makeProductImage() {
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width)
    }
}
