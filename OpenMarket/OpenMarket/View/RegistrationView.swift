//
//  RegistrationView.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

class RegistrationView: UIView {
  
  init() {
    super.init(frame: .zero)
    configureLayout()
    self.backgroundColor = .white
    self.translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  //MARK: - image scroll part
  private let imageScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  let addImageButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .systemGray4
    button.setTitle("+", for: .normal)
    button.setTitleColor(UIColor.systemBlue, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  //MARK: - text field part
  private let nameTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "상품명"
    textField.borderStyle = .roundedRect
    textField.backgroundColor = .white
    textField.keyboardType = .default
    return textField
  }()
  
  private let priceTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "상품가격"
    textField.borderStyle = .roundedRect
    textField.backgroundColor = .white
    textField.keyboardType = .numberPad
    return textField
  }()
  
  private let currencySegmentedControl: UISegmentedControl = {
    let segmentedControl = UISegmentedControl(items: ["KRW", "USD"])
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    segmentedControl.setContentCompressionResistancePriority(.required, for: .horizontal)
    return segmentedControl
  }()
  
  private let discountedPriceTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "할인금액"
    textField.borderStyle = .roundedRect
    textField.backgroundColor = .white
    textField.keyboardType = .numberPad
    return textField
  }()
  
  private let stockTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "재고수량"
    textField.borderStyle = .roundedRect
    textField.backgroundColor = .white
    textField.keyboardType = .numberPad
    return textField
  }()
  //MARK: - description part
  private let descriptionTextField: UITextView = {
    let textView = UITextView()
    textView.backgroundColor = .white
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.keyboardType = .default
    textView.font = .systemFont(ofSize: 17)
    return textView
  }()
  //MARK: - stack view
  let imageStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 5
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let imageWithButtonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 5
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let priceStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 5
    return stackView
  }()
  
  private let textFieldStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 5
    return stackView
  }()
  
  private let totalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 10
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  //MARK: - layout
  private func configureLayout() {
    imageScrollView.addSubview(imageWithButtonStackView)
    imageWithButtonStackView.addArrangedSubviews(imageStackView, addImageButton)
    priceStackView.addArrangedSubviews(priceTextField, currencySegmentedControl)
    textFieldStackView.addArrangedSubviews(nameTextField, priceStackView, discountedPriceTextField, stockTextField)
    totalStackView.addArrangedSubviews(imageScrollView, textFieldStackView, descriptionTextField)
    self.addSubview(totalStackView)
    
    NSLayoutConstraint.activate(
      [totalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
       totalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
       totalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
       totalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
       
       currencySegmentedControl.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.23),
       
       addImageButton.widthAnchor.constraint(equalTo: addImageButton.heightAnchor, multiplier: 1),
       
       imageScrollView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.17),
       
       imageWithButtonStackView.leadingAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.leadingAnchor),
       imageWithButtonStackView.trailingAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.trailingAnchor),
       imageWithButtonStackView.topAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.topAnchor),
       imageWithButtonStackView.bottomAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.bottomAnchor),
       imageWithButtonStackView.heightAnchor.constraint(equalTo: imageScrollView.frameLayoutGuide.heightAnchor, multiplier: 1),
       descriptionTextField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6)
      ])
  }
  
  func setupParams() -> Params {
    var currency = ""
    if self.currencySegmentedControl.selectedSegmentIndex == 0 {
      currency = "KRW"
    } else {
      currency = "USD"
    }
    let params = Params(name: self.nameTextField.text!,
                        price: Int(self.priceTextField.text!)!,
                        discountedPrice: Int(self.discountedPriceTextField.text!)!,
                        stock: Int(self.stockTextField.text!)!,
                        currency: currency,
                        description: self.descriptionTextField.text!,
                        secret: "password")
    return params
  }
}
