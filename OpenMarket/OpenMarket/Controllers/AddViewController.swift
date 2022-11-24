//
//  AddViewController.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/24.
//

import UIKit

final class AddViewController: UIViewController {
    let addProductView = AddProductView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = addProductView
    }
}
