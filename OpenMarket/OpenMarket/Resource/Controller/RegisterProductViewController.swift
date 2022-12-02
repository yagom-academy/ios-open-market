//
//  RegisterProductViewController.swift
//  OpenMarket
//
//  Created by Byunghee_Yoon on 2022/12/02.
//

import UIKit

class RegisterProductViewController: UIViewController {
    
    let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    let productPriceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    let discountPriceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    let stockTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    let currencySegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: Currency.allCases.map(\.rawValue))
        
        return segment
    }()
    
    let descriptionTextView: UITextView = {
        let textview = UITextView()
        
        return textview
    }()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didtappedDoneButton)
        )
        navigationController?.title = "상품등록"
        
    }
    
    @objc func didtappedDoneButton() {
        
    }
}
