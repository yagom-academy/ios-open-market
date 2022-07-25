//
//  ListCollectionViewCell.swift
//  OpeMarket
//
//  Created by BaekGom, Brad on 2022/07/15.
//

import UIKit

class ListCollectionViewCell: UICollectionViewListCell {
    @IBOutlet private weak var productImage: UIImageView!
    @IBOutlet private weak var productName: UILabel!
    @IBOutlet private weak var productPrice: UILabel!
    @IBOutlet private weak var productDiscountPrice: UILabel!
    @IBOutlet private weak var productStock: UILabel!
    @IBOutlet private weak var spacingView: UIView!
    
    static let reuseIdentifier = "ListCollectionViewCell"
    private let numberFormatter = NumberFormatter()
    
    private func settingNumberFormaatter() {
        numberFormatter.roundingMode = .floor
        numberFormatter.numberStyle = .decimal
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.productImage.image = nil
        self.productName.text = nil
        self.productPrice.text = nil
        self.productDiscountPrice.text = nil
        self.productStock.text = nil
    }
}

extension ListCollectionViewCell {
    func fetchData(data: ProductListResponse?, index: Int) {
        self.settingNumberFormaatter()
        guard let result = data,
              let imageURL: URL = URL(string: result.pages[index].thumbnail),
              let imageData: Data = try? Data(contentsOf: imageURL) else {
            return
        }
        
        let productStock = result.pages[index].stock
        let isCheckPrice = result.pages[index].bargainPrice
        guard let priceNumberFormatter = numberFormatter.string(from: result.pages[index].price as NSNumber) else { return }
        guard let dicountedPriceNumberFormatter = numberFormatter.string(from: result.pages[index].discountedPrice as NSNumber) else { return }
        
        self.productImage.image = UIImage(data: imageData)
        self.productName.text = result.pages[index].name
        self.productPrice.attributedText = .none
        self.productDiscountPrice.attributedText = .none
        self.spacingView.isHidden = true
        self.isSelected = false
        
        self.productStock.text = "잔여수량 : \(productStock)"
        self.productStock.textColor = .systemGray
        self.productDiscountPrice.textColor = .systemGray
        self.productDiscountPrice.text = "\(result.pages[index].currency): \(priceNumberFormatter)"
        
        if productStock == 0 {
            self.productStock.text = "품절"
            self.productStock.textColor = .orange
        }
        
        if isCheckPrice > 0 {
            self.spacingView.isHidden = false
            self.productPrice.textColor = .systemRed
            self.productPrice.text = "\(result.pages[index].currency): \(priceNumberFormatter)"
            self.productPrice.attributedText = self.productPrice.text?.strikeThrough()
            self.productDiscountPrice.textColor = .systemGray
            self.productDiscountPrice.text = "\(result.pages[index].currency): \(dicountedPriceNumberFormatter)"
        }
    }
}
