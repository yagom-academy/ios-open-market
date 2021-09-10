//
//  EnrollModifyViewController.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/10.
//

import UIKit

class EnrollModifyViewController: UIViewController {
    @IBOutlet weak var postPatchButton: UIBarButtonItem!
    var topItemTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "상품" + topItemTitle
        postPatchButton.title = topItemTitle
    }
}
