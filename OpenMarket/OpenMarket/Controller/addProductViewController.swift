//
//  addProductViewController.swift
//  OpenMarket
//
//  Created by Seul Mac on 2022/01/19.
//

import UIKit

class AddProductViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = "상품등록"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}
