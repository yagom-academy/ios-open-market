//
//  UIRefreshControl+Extensions.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

extension UIRefreshControl {
    func stop() {
        if isRefreshing {
            endRefreshing()
        }
    }
}
