//
//  OpenMarketGridCell.swift
//  OpenMarket
//
//  Created by Ellen on 2021/08/25.
//

import UIKit

class OpenMarketGridCell: UICollectionViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    static let cellIdentifier = "\(OpenMarketGridCell.self)"
    
    override func prepareForReuse() {
        itemImage.image = nil
        titleLabel.text = nil
        discountedPriceLabel.text = nil
        priceLabel.attributedText = nil
        priceLabel.textColor = .gray
        stockLabel.text = nil
        stockLabel.textColor = .gray
    }
    
    func setUpLabels(item: [Item], indexPath: IndexPath) {
        titleLabel.textColor = .black
        priceLabel.textColor = .gray
        discountedPriceLabel.textColor = .gray
        stockLabel.textColor = .gray
        
        let item = item[indexPath.item]
        titleLabel.text = item.title
        priceLabel.text = PriceFormatter(iso: item.currency, price: item.price).formatNumber()
        stockLabel.text = "\(item.stock)"
        
        if let discountedPrice = item.discountedPrice {
            let formatedDiscountedPrice = PriceFormatter(iso: item.currency, price: discountedPrice).formatNumber()
            let formattedPrice = PriceFormatter(iso: item.currency, price: item.price).formatNumber()
            let attributedString = NSMutableAttributedString(string: formattedPrice)
            attributedString.addAttribute(.baselineOffset, value: 0, range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString.length))
            discountedPriceLabel.text = formatedDiscountedPrice
            priceLabel.attributedText = attributedString
            priceLabel.textColor = .red
        } else {
            discountedPriceLabel.text = ""
        }
        
        if item.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .orange
        } else {
            stockLabel.text = "잔여수량 : \(item.stock)"
        }
    }
    
    func setUpImages(url: String) {
        ImageLoader(imageUrl: url).loadImage { image in
            DispatchQueue.main.async {
                self.itemImage.image = image
            }
        }
    }
    
    func configureCellStyle() {
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.systemGray5.cgColor
    }
}
