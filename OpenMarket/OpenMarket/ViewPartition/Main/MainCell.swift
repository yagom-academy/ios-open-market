//
//  MainCell.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/26.
//

import UIKit

class MainCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var remainedStockLabel: UILabel!
    
    private let stockPrefix = "잔여수량 : "
    private let space = " "
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layerStyling()
        initializeDefaultAccessibility()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layerStyling()
        initializeDefaultAccessibility()
    }
    
    func configure(with item: Goods) {
        configureData(with: item)
        configureAccessibility(with: item)
    }
    
    private func configureData(with item: Goods) {
        let pricePrefix = item.currency + space
        drawImage(with: item.thumbnailURLs.first)
        titleLabel.text = item.title
        originalPriceLabel.text = NumberFormatter.toDecimal(
            from: item.price,
            withPrefix: pricePrefix
        )
        discountedPriceLabel.text = NumberFormatter.toDecimal(
            from: item.discountedPrice,
            withPrefix: pricePrefix
        )
        remainedStockLabel.text = stockPrefix + item.stock.description
    }
    
    private func initializeDefaultAccessibility() {
        discountedPriceLabel.accessibilityLabel = "할인가 : "
    }
    
    private func configureAccessibility(with item: Goods) {
        if discountedPriceLabel.text != nil,
           let text = originalPriceLabel.text{
            originalPriceLabel.isAccessibilityElement = false
            discountedPriceLabel.isAccessibilityElement = true
            
            let string = NSMutableAttributedString(string: text)
            let range = NSRange(location: 0, length: string.length)
            string.addAttribute(.strikethroughStyle, value: 1, range: range)
            string.addAttribute(.foregroundColor, value: UIColor.gray, range: range)
            
            
            originalPriceLabel.attributedText = string
        } else {
            originalPriceLabel.isAccessibilityElement = true
            discountedPriceLabel.isAccessibilityElement = false
            
            discountedPriceLabel.accessibilityLabel = nil
            originalPriceLabel.accessibilityValue = originalPriceLabel.text
        }
    }
    
    private func drawImage(with path: String?) {
        guard let path = path else {
            return
        }
        
        do {
            try NetworkManager.shared.getAnImage(with: path) { [weak self] result in
                switch result {
                case .success(let data):
                    let imageData = UIImage(data: data)
                    DispatchQueue.main.async {
                        self?.imageView.image = imageData
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func layerStyling() {
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
    }
}
