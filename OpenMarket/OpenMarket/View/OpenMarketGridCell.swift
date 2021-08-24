//
//  OpenMarketGridCell.swift
//  OpenMarket
//
//  Created by Ellen on 2021/08/25.
//

import UIKit

class OpenMarketGridCell: UICollectionViewCell {
    static let cellIdentifier = "\(OpenMarketGridCell.self)"
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
    }
    
    override func prepareForReuse() {
        itemImage.image = nil
        
        titleLabel.text = nil
        priceLabel.attributedText = nil
        discountedPriceLabel.text = nil
        stockLabel.text = nil
        
        titleLabel.textColor = .black
        priceLabel.textColor = .gray
        discountedPriceLabel.textColor = .gray
        stockLabel.textColor = .gray
    }
    
    func setUpLabels(item: [Item], indexPath: IndexPath) {
        let item = item[indexPath.item]
        titleLabel.text = item.title
        stockLabel.text = "\(item.stock)"
        if let discountedPrice = item.discountedPrice {
            discountedPriceLabel.text = PriceFormatter(iso: item.currency, price: discountedPrice).formatNumber()
            priceLabel.attributedText = PriceFormatter(iso: item.currency, price: item.price).formatNumber().strikethroughStyle()
            priceLabel.textColor = .red
        } else {
            priceLabel.text = PriceFormatter(iso: item.currency, price: item.price).formatNumber()
            discountedPriceLabel.text = ""
        }
        stockLabel.text = item.stock > 10000 ? "잔여수량 : 9999개" : item.stock > 0 ? "잔여수량 : \(item.stock)개" : "품절"
        if item.stock <= 0 {
            stockLabel.textColor = .orange
        }
    }
    
    func setUpImages(url: String) {
        ImageLoader(imageUrl: url).loadImage { image in
            DispatchQueue.main.async {
                self.itemImage.image = image
            }
        }
    }
}

extension String {
    func strikethroughStyle() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(.baselineOffset, value: 0, range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
}
