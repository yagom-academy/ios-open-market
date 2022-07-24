//
//  OpenMarket - MarketProductsViewController.swift
//  Created by 데릭, 케이, 수꿍. 
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class MarketProductsViewController: UIViewController {
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let marketProductView = MarketProductsView(self)
        view.addSubview(marketProductView)
    }
}


