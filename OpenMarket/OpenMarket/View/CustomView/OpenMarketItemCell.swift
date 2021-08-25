//
//  OpenMarketItemCell.swift
//  OpenMarket
//
//  Created by 김준건 on 2021/08/20.
//

import UIKit

class OpenMarketItemCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var strikethroughRedLabel: UILabel!
    @IBOutlet private weak var normalGrayLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!
    private var imageDataTask: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLabelsConfiguration()
    }
}

//MARK:- SetUp Label's Attributes
extension OpenMarketItemCell {
    private func setUpLabelsConfiguration() {
        
        titleLabel.adjustsFontSizeToFitWidth = true
        normalGrayLabel.adjustsFontSizeToFitWidth = true
        strikethroughRedLabel.adjustsFontSizeToFitWidth = true
        stockLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel.minimumScaleFactor = 0.1
        normalGrayLabel.minimumScaleFactor = 0.1
        strikethroughRedLabel.minimumScaleFactor = 0.1
        stockLabel.minimumScaleFactor = 0.1
        
        titleLabel.numberOfLines = 2
        normalGrayLabel.numberOfLines = 1
        strikethroughRedLabel.numberOfLines = 1
        stockLabel.numberOfLines = 1
        
        titleLabel.lineBreakMode = .byClipping
        normalGrayLabel.lineBreakMode = .byClipping
        strikethroughRedLabel.lineBreakMode = .byClipping
        stockLabel.lineBreakMode = .byClipping
    }
}

//MARK:- SetUp Cell's Contents
extension OpenMarketItemCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        imageDataTask?.cancel()
        imageDataTask = nil
    }
    
    func configure(image: UIImage?) {
        imageView.image = image
    }
    
    func configure(from product: Product, with dataTask: URLSessionDataTask?) {
        resetContents()
        
        imageDataTask = dataTask
        titleLabel.text = product.title
        setUpStockLabel(by: product.stock)
        setUpPriceLabels(by: product)
    }
    
    private func resetContents() {
        imageView.image = #imageLiteral(resourceName: "WaitingImage")
        titleLabel.text = nil
        strikethroughRedLabel.text = nil
        stockLabel.text = nil
        normalGrayLabel.text = nil
    }
    
    private func setUpStockLabel(by number: Int) {
        if number == .zero {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemOrange
        } else {
            stockLabel.text = "잔여 수량: " + number.description
            stockLabel.textColor = .systemGray2
        }
    }
    
    private func setUpPriceLabels(by product: Product) {
        let formattedPriceValue = format(number: product.price, accordingTo: product.currency)
        if let discountedPrice = product.discountedPrice {
            strikethroughRedLabel.attributedText = createStrikeThroughString(from: formattedPriceValue)
            normalGrayLabel.text = format(number: discountedPrice, accordingTo: product.currency)
        } else {
            normalGrayLabel.text = formattedPriceValue
        }
    }
    
    private func format(number: Int, accordingTo currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        
        let formattedNumber = formatter.string(from: NSNumber(value: number)) ?? number.description
        return formattedNumber
    }
    
    private func createStrikeThroughString(from value: String) -> NSMutableAttributedString {
        let lineStyle = NSUnderlineStyle.thick.rawValue
        let attributedValue = NSMutableAttributedString(string: value)
        
        attributedValue.addAttribute(.strikethroughStyle, value: lineStyle, range: NSMakeRange(.zero, attributedValue.length))
        return attributedValue
    }
}
