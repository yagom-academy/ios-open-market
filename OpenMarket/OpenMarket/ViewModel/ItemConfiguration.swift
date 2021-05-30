//
//  ItemConfiguration.swift
//  OpenMarket
//
//  Created by 윤재웅 on 2021/05/26.
//

import UIKit
import Foundation

@available(iOS 14.0, *)
struct ItemConfiguration: UIContentConfiguration, Hashable {
    var image: [String]?
    var title: String?
    var stock: UInt?
    var price: UInt?
    var discountPrice: UInt?
    var currency: String?
    var mode: String?
    
    func makeContentView() -> UIView & UIContentView {
        if mode == "List" {
            return ItemContentView(configuration: self)
        } else {
            return ItemGridContentView(configuration: self)
        }
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}
