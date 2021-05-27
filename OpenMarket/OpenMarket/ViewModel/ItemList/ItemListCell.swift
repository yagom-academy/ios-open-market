//
//  ItemListCell.swift
//  OpenMarket
//
//  Created by 윤재웅 on 2021/05/26.
//

import Foundation
import UIKit

@available(iOS 14.0, *)
class ItemListCell: UICollectionViewListCell {
    
    var item: MarketItems.Infomation?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfiguration = ItemConfiguration().updated(for: state)
        newConfiguration.image = item?.thumbnails
        newConfiguration.title = item?.title
        newConfiguration.stock = item?.stock
        newConfiguration.price = item?.price
        newConfiguration.discountPrice = item?.discountedPrice
        newConfiguration.currency = item?.currency
        contentConfiguration = newConfiguration
        
        var newBgConfiguration = UIBackgroundConfiguration.listGroupedCell()
        newBgConfiguration.backgroundColor = .systemBackground
        backgroundConfiguration = newBgConfiguration
    }
}
