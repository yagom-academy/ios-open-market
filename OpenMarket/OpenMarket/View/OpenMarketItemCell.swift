//
//  OpenMarketItemCell.swift
//  OpenMarket
//
//  Created by KimJaeYoun on 2021/08/20.
//

import UIKit

class OpenMarketItemCell: UICollectionViewCell, StrockText, DigitStyle {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    //MARK: Property
    private var isImageDownload = false
}

extension OpenMarketItemCell {
    
    //MARK: Method
    func configure(item: OpenMarketItems.Item, _ indexPath: IndexPath) {
        titleLabel.text = item.title
        downloadImage(reqeustURL: item.thumbnails.first ?? "", indexPath)
        
        if item.stock == 0 {
            statusLabel.text = "품절"
            statusLabel.textColor = .systemYellow
        } else {
            let stock = apply(to: item.stock)
            statusLabel.textColor = .systemGray
            statusLabel.text = "잔여수량: \(stock)"
        }
        
        if let discountedPrice = item.discountedPrice {
            
            discountedPriceLabel.textColor = .systemGray
            discountedPriceLabel.text = "\(item.currency) \(apply(to: discountedPrice))"
            let strockText = strock(text: "\(item.currency)" + apply(to: item.price))
            priceLabel.attributedText = strockText
            priceLabel.textColor = .systemRed
        } else {
            discountedPriceLabel.isHidden = true
            priceLabel.textColor = .systemGray
            priceLabel.text = "\(item.currency) \(apply(to: item.price))"
        }
        
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.layer.cornerRadius = 15
    }
    
    func downloadImage(reqeustURL: String, _ indexPath: IndexPath) {
        URLSession.shared.dataTask(with: URL(string: reqeustURL)!) { data, _, _ in
            guard let data = data else { return }
            
            guard let downloadImage = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.itemImage.image = downloadImage
                if self.isImageDownload == false {
                    NotificationCenter.default.post(name: .imageDidDownload, object: nil)
                    self.isImageDownload = true
                }
            }
        }.resume()
    }
    
    override func prepareForReuse() {
        priceLabel.attributedText = nil
        priceLabel.text = nil
        priceLabel.textColor = .black

        discountedPriceLabel.textColor = .black
        discountedPriceLabel.text = nil
        discountedPriceLabel.isHidden = false
        
        statusLabel.textColor = .black
        statusLabel.text = nil
        
        titleLabel.text = nil
    }
}
