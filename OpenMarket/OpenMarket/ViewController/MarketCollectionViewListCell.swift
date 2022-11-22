//
//  MarketCollectionViewListCell.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/22.
//

import UIKit

class MarketCollectionViewListCell: UICollectionViewListCell {
    var pageData: Page?
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.pageData = self.pageData
        return state
    }
}

extension UIConfigurationStateCustomKey {
    static let page = UIConfigurationStateCustomKey("page")
}

extension UIConfigurationState {
    var pageData: Page? {
        get { return self[.page] as? Page }
        set { self[.page] = newValue }
    }
}
