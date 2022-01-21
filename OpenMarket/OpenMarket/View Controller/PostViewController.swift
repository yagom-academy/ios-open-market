//
//  PostViewController.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/21.
//

import UIKit

class PostViewController: UIViewController {
    var postStackView = UIStackView()
    let imageScrollView = UIScrollView()
    let productInfoStackView = UIStackView()
    var productNameTextField = UITextField()
    let priceStackView = UIStackView()
    var priceTextField = UITextField()
    let currencySwitchButton = UISegmentedControl()
    var bargainPriceTextField = UITextField()
    var stockTextField = UITextField()
    var descriptionTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStackView()
    }
    
    func configureStackView() {
        view.addSubview(postStackView)
        postStackView.axis = .vertical
        postStackView.distribution = .fill
        postStackView.spacing = 10
        
        setUpStackViewConstraints()
        addViewToPostStackView()
        addViewToProductInfoStackView()
        addViewToPriceStackView()
        setUpConstraints()
        addPlaceHolderToTextField()
    }
    
    func addViewToPostStackView() {
        postStackView.addArrangedSubview(imageScrollView)
        postStackView.addArrangedSubview(productInfoStackView)
        postStackView.addArrangedSubview(descriptionTextView)
    }
    
    func addViewToProductInfoStackView() {
        productInfoStackView.addArrangedSubview(productNameTextField)
        productInfoStackView.addArrangedSubview(priceStackView)
        productInfoStackView.addArrangedSubview(bargainPriceTextField)
        productInfoStackView.addArrangedSubview(stockTextField)
    }
    
    func addViewToPriceStackView() {
        priceStackView.addArrangedSubview(priceTextField)
        priceStackView.addArrangedSubview(currencySwitchButton)
    }
    
    func addPlaceHolderToTextField() {
        productNameTextField.placeholder = "상품명"
        priceTextField.placeholder = "상품가격"
        bargainPriceTextField.placeholder = "할인금액"
        stockTextField.placeholder = "재고수량"
    }
    
    func setUpStackViewConstraints() {
        postStackView.translatesAutoresizingMaskIntoConstraints = false
        postStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        postStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        postStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        postStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }
    
    func setUpConstraints() {
        imageScrollViewConstraints()
        productInfoStackViewConstraints()
        productNameTextFieldConstraints()
        priceStackViewConstraints()
        priceTextFieldConstraints()
        currencySwitchButtonConstraints()
        bargainPriceTextFieldConstraints()
        stockTextFieldConstraints()
        descriptionTextViewConstraints()
    }
    
    func imageScrollViewConstraints() {
        
    }
    
    func productInfoStackViewConstraints() {
        
    }
    
    func productNameTextFieldConstraints() {
        
    }
    
    func priceStackViewConstraints() {
        
    }
    
    func priceTextFieldConstraints() {
        
    }
    
    func currencySwitchButtonConstraints() {
        
    }
    
    func bargainPriceTextFieldConstraints() {
        
    }
    
    func stockTextFieldConstraints() {
        
    }
    
    func descriptionTextViewConstraints() {
        
    }
}
