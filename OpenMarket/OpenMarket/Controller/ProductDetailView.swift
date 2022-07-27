//
//  ProductDetailView.swift
//  OpenMarket
//
//  Created by 김동용 on 2022/07/27.
//

import UIKit

class ProductDetailView: UIView {
    // MARK: - properties
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .black
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .blue
        
        return stackView
    }()
    
    private let productInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .brown
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private let segmentedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .systemBlue
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private let productDescriptionTextField: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .darkGray
        
        return textField
    }()
    
    private let productName: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .green
        
        return textField
    }()
    
    private let productPrice: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .orange
        
        return textField
    }()
    
    private let productDiscountedPrice: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .purple
        
        return textField
    }()
    
    private let stock: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .red
        
        return textField
    }()
    
    private let priceSegmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.backgroundColor = .white
        return segment
    }()
    
    // MARK: - functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setSubViews()
        setTotalStackSubviews()
        setSegmentedStackView()
        setTotalStackViewConstraints()
        setUpProductDescriptionTextField()
        setUpasdfsadf()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubViews() {
        self.addSubview(totalStackView)
    }
    
    func setTotalStackSubviews() {
        [imageStackView, productInformationStackView, productDescriptionTextField]
            .forEach { totalStackView.addArrangedSubview($0) }
        [productName, segmentedStackView, productDiscountedPrice, stock].forEach { productInformationStackView.addArrangedSubview($0) }
    }
    
    func setSegmentedStackView() {
        [productPrice, priceSegmentedControl]
            .forEach { segmentedStackView.addArrangedSubview($0) }
    }
    
    func setTotalStackViewConstraints() {
        NSLayoutConstraint.activate(
            [totalStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
             totalStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
             totalStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
             totalStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
    
    func setUpProductDescriptionTextField() {
        NSLayoutConstraint.activate([productDescriptionTextField.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)])
    }
    
    func setUpasdfsadf() {
        NSLayoutConstraint.activate([productInformationStackView.heightAnchor.constraint(equalTo: productDescriptionTextField.heightAnchor, multiplier: 0.5),
                                    ])
    }
}
