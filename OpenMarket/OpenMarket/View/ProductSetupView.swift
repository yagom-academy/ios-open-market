//
//  ProductSetupView.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/28.
//

import UIKit

class ProductSetupView: UIView {
    let mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var mainStackView: UIStackView = {
        var stackview = UIStackView(arrangedSubviews: [horizontalScrollView,
                                                       productNameTextField,
                                                       priceStackView,
                                                       productDiscountedPriceTextField,
                                                       productStockTextField,
                                                       descriptionTextView])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .fill
        stackview.spacing = 10
        return stackview
    }()
    
    let horizontalScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var horizontalStackView: UIStackView = {
        var stackview = UIStackView()
        //stackview.addArrangedSubview(addImageButton)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.distribution = .fill
        stackview.alignment = .fill
        stackview.spacing = 10
        return stackview
    }()
    
    let addImageButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .lightGray
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return button
    }()
    
    let productNameTextField: UITextField = {
        var textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "상품명"
        textfield.setupLayer()
        textfield.addLeftPadding()
        return textfield
    }()
    
    lazy var priceStackView: UIStackView = {
        var stackview = UIStackView(arrangedSubviews: [productPriceTextField,
                                                       currencySegmentControl])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.distribution = .fill
        stackview.alignment = .fill
        stackview.spacing = 10
        return stackview
    }()
    
    let productPriceTextField: UITextField = {
        var textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "상품가격"
        textfield.setupLayer()
        textfield.addLeftPadding()
        return textfield
    }()
    
    let currencySegmentControl: UISegmentedControl = {
        var segment = UISegmentedControl(items: ["KRW","USD"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    let productDiscountedPriceTextField: UITextField = {
        var textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "할인금액"
        textfield.setupLayer()
        textfield.addLeftPadding()
        return textfield
    }()
    
    let productStockTextField: UITextField = {
        var textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "재고수량"
        textfield.setupLayer()
        textfield.addLeftPadding()
        return textfield
    }()
    
    let descriptionTextView: UITextView = {
        var textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.text = "asdfasdfasdf"
        textview.isScrollEnabled = false
        return textview
    }()
    
    private var rootViewController: UIViewController?
    
    init(_ rootViewController: UIViewController) {
        super.init(frame: .null)
        self.rootViewController = rootViewController
        addSubViews(rootViewController)
        setupConstraints(rootViewController)
        keyboardTypeSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews(_ rootViewController: UIViewController) {
        rootViewController.view.addSubview(mainScrollView)
        mainScrollView.addSubview(mainStackView)
        horizontalScrollView.addSubview(horizontalStackView)
    }
    
    private func setupConstraints(_ rootViewController: UIViewController) {
        let mainStackViewHeightAnchor = mainStackView.heightAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.heightAnchor)
        mainStackViewHeightAnchor.priority = UILayoutPriority(rawValue: UILayoutPriority.defaultLow.rawValue)
        
        let horizontalStackViewWidthAnchor = horizontalStackView.widthAnchor.constraint(equalTo: horizontalScrollView.frameLayoutGuide.widthAnchor)
        horizontalStackViewWidthAnchor.priority = UILayoutPriority(rawValue: UILayoutPriority.defaultLow.rawValue)
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            mainStackViewHeightAnchor,
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor, constant: -10),
            mainStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            horizontalScrollView.heightAnchor.constraint(equalToConstant: 100),
            horizontalScrollView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            horizontalScrollView.bottomAnchor.constraint(equalTo: productNameTextField.topAnchor, constant: -10),
            horizontalScrollView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            horizontalScrollView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            horizontalStackViewWidthAnchor,
            horizontalStackView.topAnchor.constraint(equalTo: horizontalScrollView.contentLayoutGuide.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: horizontalScrollView.contentLayoutGuide.bottomAnchor),
            horizontalStackView.heightAnchor.constraint(equalTo: horizontalScrollView.heightAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: horizontalScrollView.contentLayoutGuide.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: horizontalScrollView.contentLayoutGuide.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            productNameTextField.heightAnchor.constraint(equalToConstant: 35),
            productPriceTextField.heightAnchor.constraint(equalToConstant: 35),
            productPriceTextField.widthAnchor.constraint(equalTo: priceStackView.widthAnchor, multiplier: 0.7),
            productDiscountedPriceTextField.heightAnchor.constraint(equalToConstant: 35),
            productStockTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    private func keyboardTypeSetup() {
        productNameTextField.keyboardType = .default
        productPriceTextField.keyboardType = .numberPad
        productDiscountedPriceTextField.keyboardType = .numberPad
        productStockTextField.keyboardType = .numberPad
    }
}
