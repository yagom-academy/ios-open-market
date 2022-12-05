//
//  AddItemView.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/12/05.
//

import UIKit

final class AddItemView: UIView {
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        
        return imageView
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        
        return button
    }()
    
    private let productNameTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private let priceTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private let priceForSaleTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private let stockTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private let currencySegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["KRW", "USD"])
        
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        
        
        return control
    }()
    
    private let descTextView: UITextView = {
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .lightGray
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        self.addSubview(productImageView)
        self.addSubview(plusButton)
        self.addSubview(labelStackView)
        self.addSubview(descTextView)
        
        labelStackView.addArrangedSubview(productNameTextField)
        labelStackView.addArrangedSubview(priceStackView)
        labelStackView.addArrangedSubview(priceForSaleTextField)
        labelStackView.addArrangedSubview(stockTextField)
        
        priceStackView.addArrangedSubview(priceTextField)
        priceStackView.addArrangedSubview(currencySegmentControl)
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            productImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            productImageView.heightAnchor.constraint(equalToConstant: 150),
            productImageView.widthAnchor.constraint(equalToConstant: 150),
            
            plusButton.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor),
            plusButton.topAnchor.constraint(equalTo: productImageView.topAnchor),
            plusButton.heightAnchor.constraint(equalTo: productImageView.heightAnchor),
            plusButton.widthAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            labelStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            labelStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            labelStackView.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 10),
            labelStackView.bottomAnchor.constraint(equalTo: descTextView.topAnchor, constant: -10),
            
            descTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            descTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            descTextView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 10),
            descTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        
        
    }
}
