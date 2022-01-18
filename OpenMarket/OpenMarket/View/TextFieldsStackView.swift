//
//  TextFieldsStackView.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/18.
//

import UIKit

class TextFieldsStackView: UIStackView {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var currency: UISegmentedControl!
    @IBOutlet weak var discountedPriceTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
