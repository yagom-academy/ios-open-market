//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/23.
//

import UIKit

class RegisterViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "상품등록"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = doneButton
        
    }
  
}
