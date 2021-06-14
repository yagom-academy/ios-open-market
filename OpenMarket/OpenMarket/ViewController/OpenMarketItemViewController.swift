//
//  OpenMarketItemViewController.swift
//  OpenMarket
//
//  Created by James on 2021/06/14.
//

import UIKit

class OpenMarketItemViewController: UIViewController {
    let currencyList = ["KRW", "USD", "BTC", "JPY", "EUR", "GBP", "CNY"]
    
    // MARK: - Views
    
    private lazy var itemTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명:"
        textField.textColor = .black
        return textField
    }()
    
    private lazy var currencyTextField: UITextField = {
        let textField = UITextField()
        textField.inputView = currencyPickerView
        textField.inputAccessoryView = pickerViewToolbar
        return textField
    }()
    
    private lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "가격:"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var discountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "(optional) 할인 가격:"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var stockTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "수량:"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var detailedInformationTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .darkGray
        return textView
    }()
    
    private lazy var currencyPickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 300))
        pickerView.backgroundColor = UIColor.white
        return pickerView
    }()
    
    private lazy var pickerViewToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.donePicker))
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.donePicker))
        
        toolbar.setItems([doneButton, cancelButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
