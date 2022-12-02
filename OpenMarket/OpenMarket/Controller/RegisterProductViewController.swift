//
//  RegisterProductViewController.swift
//  OpenMarket
//
//  Created by Mangdi on 2022/12/02.
//

import UIKit

class RegisterProductViewController: UIViewController {
    let networkCommunication = NetworkCommunication()
    
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!

    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productDiscountedPriceTextField: UITextField!
    @IBOutlet weak var productStockTextField: UITextField!
    @IBOutlet weak var productCurrencySegmentedControl: UISegmentedControl!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func touchUpCancelBarButtonItem(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func touchUpDoneBarButtonItem(_ sender: UIBarButtonItem) {

        self.dismiss(animated: true)
    }
    
}
