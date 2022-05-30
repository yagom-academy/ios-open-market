//
//  ProductUpdaterView.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

class ProductUpdaterView: UIView {
  enum Constants {
    static let nameText = "상품명"
    static let priceText = "상품가격"
    static let discountedPriceText = "할인금액"
    static let stockText = "재고수량"
    static let buttonTitle = "+"
    static let secret = "pqnoec089z"
    static let textViewFontSize: Double = 17
    static let stackViewSpacing: Double = 5
    static let anchorSpacing: Double = 10
    static let currencyWidthScale: Double = 0.23
    static let scrollViewHeightScale: Double = 0.17
    static let textViewHeightScale: Double = 0.6
  }
  
  init() {
    super.init(frame: .zero)
    self.backgroundColor = .white
    self.translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  //MARK: - image scroll part
  let imageScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  //MARK: - text field part
  let nameTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = Constants.nameText
    textField.borderStyle = .roundedRect
    textField.backgroundColor = .white
    textField.keyboardType = .default
    return textField
  }()
  
  let priceTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = Constants.priceText
    textField.borderStyle = .roundedRect
    textField.backgroundColor = .white
    textField.keyboardType = .numberPad
    return textField
  }()
  
  let currencySegmentedControl: UISegmentedControl = {
    let segmentedControl = UISegmentedControl(items: [Currency.won.rawValue, Currency.dollar.rawValue])
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    segmentedControl.setContentCompressionResistancePriority(.required, for: .horizontal)
    return segmentedControl
  }()
  
  let discountedPriceTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = Constants.discountedPriceText
    textField.borderStyle = .roundedRect
    textField.backgroundColor = .white
    textField.keyboardType = .numberPad
    return textField
  }()
  
  let stockTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = Constants.stockText
    textField.borderStyle = .roundedRect
    textField.backgroundColor = .white
    textField.keyboardType = .numberPad
    return textField
  }()
  //MARK: - description part
  let descriptionTextView: UITextView = {
    let textView = UITextView()
    textView.backgroundColor = .white
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.keyboardType = .default
    textView.font = .systemFont(ofSize: Constants.textViewFontSize)
    return textView
  }()
  //MARK: - stack view
  let imageStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = Constants.stackViewSpacing
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  let priceStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = Constants.stackViewSpacing
    return stackView
  }()
  
  let textFieldStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = Constants.stackViewSpacing
    return stackView
  }()
  
  let totalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = Constants.stackViewSpacing
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  func setupParams() -> Params? {
    var currency = ""
    switch self.currencySegmentedControl.selectedSegmentIndex {
    case Currency.won.number:
      currency = Currency.won.rawValue
    case Currency.dollar.number:
      currency = Currency.dollar.rawValue
    default:
      currency = Currency.won.rawValue
    }
    guard let name = self.nameTextField.text,
          let price = self.priceTextField.text,
          let discountedPrice = self.discountedPriceTextField.text,
          let stock = self.stockTextField.text,
          let descriptions = self.descriptionTextView.text
    else {
      return nil
    }
    
    guard !name.isEmpty &&
            !price.isEmpty &&
            !discountedPrice.isEmpty &&
            !stock.isEmpty &&
            !descriptions.isEmpty
    else {
      return nil
    }
    
    let params = Params(name: name,
                        price: price.integer,
                        discountedPrice: discountedPrice.integer,
                        stock: stock.integer,
                        currency: currency,
                        descriptions: descriptions,
                        secret: Constants.secret)
    return params
  }
}

