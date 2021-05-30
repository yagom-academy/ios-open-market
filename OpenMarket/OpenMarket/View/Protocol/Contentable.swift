//
//  Contentable.swift
//  OpenMarket
//
//  Created by 윤재웅 on 2021/05/30.
//

import Foundation
import UIKit

@available(iOS 14.0, *)
protocol Contentable {
    var containerView: UIView! { get set }
    var itemImageView: UIImageView! { get set }
    var title: UILabel! { get set }
    var stock: UILabel! { get set }
    var price: UILabel! { get set }
    var discountPrice: UILabel! { get set }
    var currentConfiguration: ItemConfiguration! { get set }
}

@available(iOS 14.0, *)
extension Contentable {
    
    func cancelTextLine(_ configuration: ItemConfiguration) {
        resetPrice()
        guard let price = configuration.price, let currency = configuration.currency else { return }
        if let discountPrice = configuration.discountPrice {
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: String("\(configuration.currency!) \(price)"))
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            self.price.text = String("\(currency) \(price)")
            self.price.textColor = .red
            self.price.attributedText = attributeString
            self.discountPrice.isHidden = false
            self.discountPrice.text = "\(currency) " + String(discountPrice)
        } else {
            self.price.text = String("\(currency) \(price)")
            self.discountPrice.isHidden = true
        }
    }
    
    func setSoldOutText(_ configuration: ItemConfiguration) {
        guard let stock = configuration.stock else { return }
        resetStock()
        if stock == 0 {
            self.stock.textColor = .systemOrange
            self.stock.text = String("품절")
        } else {
            self.stock.text = String("재고 : \(stock)")
        }
    }
    
    func resetPrice() {
        self.price.textColor = .systemGray
        self.price.attributedText = nil
    }
    
    func resetStock() {
        self.stock.textColor = .systemGray
    }
    
    func fetchImage(_ configuration: ItemConfiguration)   {
        self.itemImageView.image = nil
        guard let image = configuration.image, let firstImage = image.first else { return }
        guard let url = URL(string: firstImage) else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.itemImageView.image = UIImage(data: data) ?? UIImage()
            }
        }
    }
}
