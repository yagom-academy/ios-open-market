//
//  OpenMarket - MarketProductsViewController.swift
//  Created by 데릭, 케이, 수꿍. 
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class MarketProductsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let marketProductView = MarketProductsView(self)
        view.addSubview(marketProductView)
    }
}


