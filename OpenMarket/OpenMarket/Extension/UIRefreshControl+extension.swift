//
//  UIRefreshControl+extension.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/18.
//

import UIKit

extension UIRefreshControl {
    func stop() {
        if isRefreshing {
            endRefreshing()
        }
    }
}
