//
//  AddProductViewController.swift
//  OpenMarket
//
//  Created by Aaron, Jpush on 2022/11/25.
//

import UIKit

final class AddProductViewController: UIViewController {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    lazy var addProductButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.contentMode = .center
        
        let image = UIImage(systemName: "plus")
        button.setImage(image, for: .normal)
        return button
    }()
    
    let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
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
    
    let bargainPriceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .black
        textField.borderStyle = .roundedRect
        textField.placeholder = "할인금액"
        return textField
    }()
    
    let stockTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .black
        textField.borderStyle = .roundedRect
        textField.placeholder = "재고수량"
        return textField
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
        control.selectedSegmentIndex = 0
        return control
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 17.0)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configure()
        setUpUI()
    }
    
    func configure() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(tappedDoneButton))
        
        self.view.addSubview(scrollView)
        self.view.addSubview(productNameTextField)
        self.view.addSubview(priceStackView)
        self.view.addSubview(bargainPriceTextField)
        self.view.addSubview(stockTextField)
        self.view.addSubview(descriptionTextView)
        
        scrollView.addSubview(imageStackView)
        scrollView.addSubview(addProductButton)
        
        addProductButton.addTarget(self, action: #selector(tappedPlusButton), for: .touchUpInside)
        
        self.priceStackView.addArrangedSubview(productPriceTextField)
        self.priceStackView.addArrangedSubview(currencySegmentedControl)
    }
    
    func setUpUI() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 4),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
            scrollView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
            
            imageStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            addProductButton.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
            addProductButton.widthAnchor.constraint(equalTo: addProductButton.heightAnchor),
            
            productNameTextField.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 4),
            productNameTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            productNameTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
            
            priceStackView.topAnchor.constraint(equalTo: productNameTextField.bottomAnchor, constant: 4),
            priceStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            priceStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
            
            productPriceTextField.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            
            bargainPriceTextField.topAnchor.constraint(equalTo: priceStackView.bottomAnchor, constant: 4),
            bargainPriceTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            bargainPriceTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
            
            stockTextField.topAnchor.constraint(equalTo: bargainPriceTextField.bottomAnchor, constant: 4),
            stockTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            stockTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
            
            descriptionTextView.topAnchor.constraint(equalTo: stockTextField.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            descriptionTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
            descriptionTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    
    @objc
    func tappedDoneButton() {
        
    }
    
    @objc
    func tappedPlusButton(_ sender: Any) {
        print("버튼 누름")
    }
}
//
//class addProductButton: UIButton {
//    let symbol: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "plus")
//
//        return imageView
//    }()
//
//    init() {
//        super.init()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
