//
//  ProductInformationView.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/29.
//

import UIKit

final class ProductInformationView: UIView {
    private let nameTextField: UITextField = {
        let textField: UITextField = UITextField()
        
        textField.backgroundColor = .white
        textField.placeholder = "상품명"
        textField.keyboardType = .default
        
        return textField
    }()
    private let priceTextField: UITextField = {
        let textField: UITextField = UITextField()
        
        textField.backgroundColor = .white
        textField.placeholder = "상품가격"
        textField.keyboardType = .numberPad
        
        return textField
    }()
    private let bargainPriceTextField: UITextField = {
        let textField: UITextField = UITextField()
        
        textField.backgroundColor = .white
        textField.placeholder = "할인금액"
        textField.keyboardType = .numberPad
        
        return textField
    }()
    private let stockTextField: UITextField = {
        let textField: UITextField = UITextField()
        
        textField.backgroundColor = .white
        textField.placeholder = "재고수량"
        textField.keyboardType = .numberPad
        
        return textField
    }()
    private let descriptionTextView: UITextView = {
        let textView: UITextView = UITextView()
        
        textView.backgroundColor = .white
        textView.keyboardType = .default
        
        return textView
    }()
    private let currencySegmentedControl: UISegmentedControl = {
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: ["KRW", "USD"])
        
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }()
    private let priceAndCurrencyStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let contentStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private func setUpViewsIfNeeded() {
        priceAndCurrencyStackView.addArrangedSubview(priceTextField)
        priceAndCurrencyStackView.addArrangedSubview(currencySegmentedControl)
        contentStackView.addArrangedSubview(nameTextField)
        contentStackView.addArrangedSubview(priceAndCurrencyStackView)
        contentStackView.addArrangedSubview(bargainPriceTextField)
        contentStackView.addArrangedSubview(stockTextField)
        contentStackView.addArrangedSubview(descriptionTextView)
        addSubview(contentStackView)
        
        let spacing: CGFloat = 10
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing)
        ])
    }
}
