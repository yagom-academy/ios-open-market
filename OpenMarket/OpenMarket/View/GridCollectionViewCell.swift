//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/20.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var productImage: UIImageView!
    @IBOutlet private weak var productName: UILabel!
    @IBOutlet private weak var productDiscountPrice: UILabel!
    @IBOutlet private weak var productPrice: UILabel!
    @IBOutlet private weak var productStock: UILabel!
    
    static let reuseIdentifier = "GridCollectionViewCell"
    private let numberFormatter = NumberFormatter()
    
    private func settingNumberFormaatter() {
        numberFormatter.roundingMode = .floor
        numberFormatter.numberStyle = .decimal
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.productImage.image = nil
        self.productName.text = nil
        self.productDiscountPrice.text = nil
        self.productPrice.text = nil
        self.productStock.text = nil
    }
}

extension GridCollectionViewCell {
    func fetchData(data: ProductListResponse?, index: Int) {
        self.settingNumberFormaatter()
        guard let result = data else {
            return
        }
        
        let productStock = result.pages[index].stock
        guard let priceNumberFormatter = numberFormatter.string(from: result.pages[index].price as NSNumber) else { return }
        guard let dicountedPriceNumberFormatter = numberFormatter.string(from: result.pages[index].discountedPrice as NSNumber) else { return }
        
        self.productStock.text = "잔여수량 : \(productStock)"
        self.productStock.textColor = .systemGray
        self.productPrice.text = "\(result.pages[index].currency): \(priceNumberFormatter)"
        self.productPrice.textColor = .systemGray
        
        if productStock == 0 {
            self.productStock.text = "품절"
            self.productStock.textColor = .orange
        }
        
        if result.pages[index].bargainPrice > 0 {
            self.productDiscountPrice.attributedText = self.productPrice.text?.strikeThrough()
            self.productDiscountPrice.text = "\(result.pages[index].currency): \(priceNumberFormatter)"
            self.productDiscountPrice.textColor = .systemRed
            
            self.productPrice.text = "\(result.pages[index].currency): \(dicountedPriceNumberFormatter)"
            self.productPrice.textColor = .systemGray
        }
        
        self.productImage.setImageURL(result.pages[index].thumbnail)
        self.productName.text = result.pages[index].name

        self.layer.borderWidth = 2
        self.layer.cornerRadius = 20
        self.layer.borderColor = UIColor.gray.cgColor
        self.isSelected = false
    }
}
