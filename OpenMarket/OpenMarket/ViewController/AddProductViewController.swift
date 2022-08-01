//
//  AddProductViewController.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/29.
//

import UIKit

class AddProductViewController: UIViewController {
    
    override func viewDidLoad() {
        print("ok")
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
}
