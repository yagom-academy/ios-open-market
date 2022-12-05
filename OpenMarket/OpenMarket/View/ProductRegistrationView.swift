//
//  ProductRegistrationView.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/12/05.
//

import UIKit

final class ProductRegistrationView: UIView {
    private let scrollView: UIScrollView = .init()
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 1.0
        return textField
    }()
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let currencySegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["KRW", "USD"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    private let priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 1.0
        return textField
    }()
    private let discountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인금액"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 1.0
        return textField
    }()
    private let stockTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 1.0
        return textField
    }()
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .secondaryLabel
        textView.backgroundColor = .secondarySystemBackground
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        [
            priceTextField,
            currencySegmentControl
        ].forEach { priceStackView.addArrangedSubview($0) }
        
        [
            productNameTextField,
            priceStackView,
            discountedPriceTextField,
            stockTextField
        ].forEach { textFieldStackView.addArrangedSubview($0) }
        
        [
            imagesCollectionView,
            textFieldStackView,
            descriptionTextView
        ].forEach { totalStackView.addArrangedSubview($0) }
        
        scrollView.addSubview(totalStackView)
        addSubview(scrollView)
        
        let contentLayout = scrollView.contentLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -8),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            totalStackView.leadingAnchor.constraint(equalTo: contentLayout.leadingAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: contentLayout.trailingAnchor),
            totalStackView.topAnchor.constraint(equalTo: contentLayout.topAnchor),
            totalStackView.bottomAnchor.constraint(equalTo: contentLayout.bottomAnchor),
            totalStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            imagesCollectionView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor,
                                                         multiplier: 0.2),
            textFieldStackView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor,
                                                       multiplier: 0.25),
            descriptionTextView.heightAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.heightAnchor,
                                                        multiplier: 0.55),
            currencySegmentControl.widthAnchor.constraint(equalTo: priceStackView.widthAnchor,
                                                          multiplier: 0.25)
        ])
    }
}
