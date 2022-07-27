//
//  ProductRegistrationView.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/27.
//

import UIKit

class ProductRegistrationView: UIView {
    // MARK: - properties
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.setUpBoder(cornerRadius: 10,
                              borderWidth: 1.5,
                              borderColor: UIColor.systemGray3.cgColor)
        
        return scrollView
    }()
    
    private let productInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let segmentedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.setUpBoder(cornerRadius: 10,
                            borderWidth: 1.5,
                            borderColor: UIColor.systemGray3.cgColor)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private let productName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 5,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        textField.setUpBoder(cornerRadius: 10,
                             borderWidth: 1.5,
                             borderColor: UIColor.systemGray3.cgColor)
        
        return textField
    }()
    
    private let productPrice: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 5,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        textField.setUpBoder(cornerRadius: 10,
                             borderWidth: 1.5,
                             borderColor: UIColor.systemGray3.cgColor)
        
        return textField
    }()
    
    private let productDiscountedPrice: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인금액"
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 5,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        textField.setUpBoder(cornerRadius: 10,
                             borderWidth: 1.5,
                             borderColor: UIColor.systemGray3.cgColor)
        
        return textField
    }()
    
    private let stock: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 5,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        textField.setUpBoder(cornerRadius: 10,
                             borderWidth: 1.5,
                             borderColor: UIColor.systemGray3.cgColor)
        
        return textField
    }()
    
    private let priceSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Currency.krw.rawValue,
                                                          Currency.usd.rawValue])
        
        return segmentedControl
    }()
    
    // MARK: - functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .systemBackground
        self.addSubview(totalStackView)
        setUpSubviews()
        setUpTotalStackViewConstraints()
        setUpSubViewsHeight()
    }
    
    private func setUpSubviews() {
        [imageScrollView, productInformationStackView, productDescriptionTextView]
            .forEach { totalStackView.addArrangedSubview($0) }
        [productName, segmentedStackView, productDiscountedPrice, stock]
            .forEach { productInformationStackView.addArrangedSubview($0) }
        [productPrice, priceSegmentedControl]
            .forEach { segmentedStackView.addArrangedSubview($0) }
    }
    
    private func setUpTotalStackViewConstraints() {
        NSLayoutConstraint.activate(
            [totalStackView.topAnchor
                .constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
             totalStackView.leadingAnchor
                .constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
             totalStackView.trailingAnchor
                .constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
             totalStackView.bottomAnchor
                .constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)])
    }
    
    private func setUpSubViewsHeight() {
        NSLayoutConstraint.activate(
            [productDescriptionTextView.heightAnchor
                .constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor,
                            multiplier: 0.5),
             productInformationStackView.heightAnchor
                .constraint(equalTo: productDescriptionTextView.heightAnchor,
                            multiplier: 0.5)])
    }
}
