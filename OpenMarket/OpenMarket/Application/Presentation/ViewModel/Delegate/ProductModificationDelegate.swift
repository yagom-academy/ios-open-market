//
//  ProductModificationDelegate.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

protocol ProductModificationDelegate: AnyObject {
    func productModificationViewController(_ viewController: ProductModificationViewController.Type,
                            didRecieve productName: String)
}
