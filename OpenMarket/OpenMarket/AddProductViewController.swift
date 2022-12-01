//
//  AddProductViewController.swift
//  OpenMarket
//
//  Created by Aaron, Jpush on 2022/11/25.
//

import UIKit

final class AddProductViewController: UIViewController {
    let pickerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.textColor = .systemGray
        textField.tintColor = .black
        textField.borderStyle = .roundedRect
        textField.placeholder = "상품명"
        return textField
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    let productPriceTextField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.textColor = .systemGray
        textField.tintColor = .black
        textField.borderStyle = .roundedRect
        textField.placeholder = "상품가격"

        return textField
    }()
    
    let currencySegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["KRW", "USD"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configure()
        setUpUI()
    }
    
    func configure() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(tappedDoneButton))
        
        self.view.addSubview(pickerView)
        self.view.addSubview(productNameTextField)
        self.view.addSubview(priceStackView)
        
        self.priceStackView.addArrangedSubview(productPriceTextField)
        self.priceStackView.addArrangedSubview(currencySegmentedControl)
    }
    
    func setUpUI() {
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            pickerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            pickerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 4),
            pickerView.heightAnchor.constraint(greaterThanOrEqualTo: self.view.heightAnchor, multiplier: 0.3),
            
            productNameTextField.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 4),
            productNameTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            productNameTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 4),
            productNameTextField.heightAnchor.constraint(equalToConstant: 16),
            
            priceStackView.topAnchor.constraint(equalTo: productNameTextField.bottomAnchor, constant: 4),
            priceStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            priceStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 4),
            priceStackView.heightAnchor.constraint(equalToConstant: 16),
            
            
        ])
    }
    
    @objc
    func tappedDoneButton() {
        
    }
}
