//
//  GridLayoutCell.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/11.
//

import UIKit

class GridLayoutCell: UICollectionViewCell {
    static var reuseIdentifier: String { "gridCell" }
    static var nib: UINib {
        UINib(nibName: "GridLayoutCell", bundle: nil)
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        guard priceStackView.arrangedSubviews.count >= 2 else { return }
        guard let view = priceStackView.arrangedSubviews.first else { return }
        priceStackView.removeArrangedSubview(view)
    }

    func configureContents(image: UIImage, productName: String, price: String, discountedPrice: String?, stock: String) {
        imageView.image = image
        productNameLabel.text = productName
        priceLabel.text = price
        stockLabel.text = stock
        
        if let discounted = discountedPrice {
            priceLabel.textColor = .systemRed
            let attributeString =  NSMutableAttributedString(string: price)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            priceLabel.attributedText = attributeString
            let discountedLabel = UILabel()
            discountedLabel.text = discounted
            priceStackView.addArrangedSubview(discountedLabel)
        }
    }
}
