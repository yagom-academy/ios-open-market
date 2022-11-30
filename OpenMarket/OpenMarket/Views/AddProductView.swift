//
//  AddProductView.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/24.
//

import UIKit

final class AddProductView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let salePriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인가격"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let stockTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let currencySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["KRW", "USD"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.borderWidth = 1
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    lazy var priceStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [priceTextField, currencySegmentedControl])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var productStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTextField, priceStackView, salePriceTextField, stockTextField])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
}

// MARK: - Constraints
extension AddProductView {
    private func setupUI() {
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        self.addSubview(productStackView)
        self.addSubview(descriptionTextView)
    }
    
    private func setupConstraints() {
        
    }
}

