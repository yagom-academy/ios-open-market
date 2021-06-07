//
//  CellDataUpdatable.swift
//  OpenMarket
//
//  Created by James on 2021/06/07.
//

import Foundation
import UIKit

protocol CellDataUpdatable {
    var itemTitleLabel: UILabel { get set }
    var itemPriceLabel: UILabel { get set }
    var itemStockLabel: UILabel { get set }
    var itemThumbnail: UIImageView { get set }
    var itemDiscountedPriceLabel: UILabel { get set }
}
extension CellDataUpdatable {

    func configureDiscountedPriceLabel(_ itemList: OpenMarketItemList, indexPath: Int) {
        if let discountedPrice = (itemList.items[indexPath].discountedPrice) {
            itemPriceLabel.textColor = .red
            itemPriceLabel.attributedText = itemPriceLabel.text?.strikeThrough()
            itemDiscountedPriceLabel.text = "\(itemList.items[indexPath].currency) \(discountedPrice)"
        } else {
            itemDiscountedPriceLabel.text = nil
        }
        
    }
    
    func configureStockLabel(_ itemList: OpenMarketItemList, indexPath: Int) {
        if itemList.items[indexPath].stock == 0 {
            itemStockLabel.textColor = .orange
            itemStockLabel.text = "품절"
        } else {
            itemStockLabel.text = "잔여수량 : \(itemList.items[indexPath].stock)"
        }
    }
    
    func configureThumbnail(_ itemList: OpenMarketItemList, indexPath: Int) {
        guard let url = URL(string: itemList.items[indexPath].thumbnails[0]) else { return }
        downloadImage(url: url) { image in
            DispatchQueue.main.async {
                self.itemThumbnail.image = image
            }
        }
    }
    
    func downloadImage(url: URL, completionHandler: @escaping (UIImage) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let completeData = data,
                  let imageData = UIImage(data: completeData) else { return }
            completionHandler(imageData)
        }.resume()
    }
}
