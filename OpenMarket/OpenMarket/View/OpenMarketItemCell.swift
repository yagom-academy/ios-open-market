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
}

extension OpenMarketItemCell {
    // 여기서 메소드를 하나 만들어서 configure에서 메소드를 호출 -> 그 이미지를 반영
    func configure(item: OpenMarketItems.Item) {
        titleLabel.text = item.title
        downloadImage(reqeustURL: item.thumbnails.first ?? "")
        
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
    }
   
    func downloadImage(reqeustURL: String) {
        URLSession.shared.dataTask(with: URL(string: reqeustURL)!) { data, error, _ in
            
            if let error = error {
                dump(error)
            }
            guard let data = data else { return }
            
            guard let downloadImage = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.itemImage.image = downloadImage
            }
        }.resume()
    }

    override func prepareForReuse() {
        priceLabel.attributedText = nil
        discountedPriceLabel.textColor = .black
        discountedPriceLabel.text = nil
        discountedPriceLabel.isHidden = false
        
        titleLabel.text = nil
        priceLabel.text = nil
        statusLabel.textColor = .black
        statusLabel.text = nil

        priceLabel.textColor = .black

    }
}
