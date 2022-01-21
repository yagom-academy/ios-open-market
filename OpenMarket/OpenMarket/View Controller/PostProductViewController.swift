//
//  PostProductViewController.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/21.
//

import UIKit

class PostProductViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var postImageButton: UIButton!
    @IBOutlet weak var postImageListStackView: UIStackView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var currencySwitchController: UISegmentedControl!
    @IBOutlet weak var discountedPriceTextField: UITextField!
    @IBOutlet weak var productStockTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderSetting()
        
    }
    
    
    func placeholderSetting() {
        productNameTextField.delegate = self
        productPriceTextField.delegate = self
        discountedPriceTextField.delegate = self
        productStockTextField.delegate = self
        
        productNameTextField.placeholder = "상품명"
        productPriceTextField.placeholder = "상품가격"
        discountedPriceTextField.placeholder = "할인금액"
        productStockTextField.placeholder = "재고수량"
    }
    
}
