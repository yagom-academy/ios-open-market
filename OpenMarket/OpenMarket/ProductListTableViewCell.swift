//
//  ProductListTableViewCell.swift
//  OpenMarket
//
//  Created by 김태형 on 2021/01/28.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {
    let productNameLabel: UILabel = UILabel()
    let productPriceLabel: UILabel = UILabel()
    let productThumbnailImageView: UIImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(productNameLabel)
        self.contentView.addSubview(productPriceLabel)
        setUpLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLabel() {
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.font = .preferredFont(forTextStyle: .body)
        productNameLabel.adjustsFontForContentSizeCategory = true
        productNameLabel.textColor = .black
        
        productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        productPriceLabel.font = .preferredFont(forTextStyle: .body)
        productPriceLabel.adjustsFontForContentSizeCategory = true
        productPriceLabel.textColor = .black
    }
    func setUpLabelText(name: String) {
          self.productNameLabel.text = "MAC"
          self.productPriceLabel.text = "500"
      }
}
