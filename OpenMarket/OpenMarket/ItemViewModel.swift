//
//  ItemViewModel.swift
//  OpenMarket
//
//  Created by 김지혜 on 2021/02/05.
//

import UIKit

struct ItemViewModel {
    var model: Item

    init(_ model: Item) {
        self.model = model
    }
    
    var title: String {
        model.title    }
    
    var stock: String {
        if model.stock == 0 {
            return "품절"
        } else {
            return "잔여수량: \(model.stock)"
        }
    }
    
    var stockColor: UIColor {
        if model.stock == 0 {
            return .systemOrange
        } else {
            return .systemGray
        }
    }
    
    var price: String {
        "\(model.currency) \(model.price.withCommas())"
    }
    
    var discountedPrice: String? {
        if let discountedPrice = model.discountedPrice {
            return "\(model.currency) \(discountedPrice.withCommas())"
        } else {
            return nil
        }
    }
    
    var thumbnail: String? {
        return model.thumbnails.first
    }
}

extension Int {
    func withCommas() -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
