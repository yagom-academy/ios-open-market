//
//  EnrollModifyViewController.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/10.
//

import UIKit

class EnrollModifyViewController: UIViewController {
    @IBOutlet weak var postPatchButton: UIBarButtonItem!
    var productTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "상품" + productTitle
        postPatchButton.title = productTitle
        let backButton = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}
