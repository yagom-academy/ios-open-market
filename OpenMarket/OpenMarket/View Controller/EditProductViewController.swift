//
//  PostProductViewController.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/21.
//

import UIKit

class EditProductViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var postImageButton: UIButton!
    @IBOutlet weak var postImageListStackView: UIStackView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var currencySwitchController: UISegmentedControl!
    @IBOutlet weak var discountedPriceTextField: UITextField!
    @IBOutlet weak var productStockTextField: UITextField!
    @IBOutlet weak var productNavigationBar: UINavigationItem!
    var postData: ProductParam?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderSetting()
        
    }
    
    @IBAction func hitCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func hitDoneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
//        postData?.name = productNameTextField.text
//        postData?.price = productPriceTextField.text
//        postData?.discountedPrice = discountedPriceTextField.text
//        postData?.stock = productStockTextField.text
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editProductView = segue.destination as? EditProductViewController {
            editProductView.productNavigationBar.title = "상품수정"
        }
    }
}
