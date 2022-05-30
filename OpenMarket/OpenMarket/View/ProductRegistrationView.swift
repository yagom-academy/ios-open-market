//
//  ProductRegistrationView.swift
//  OpenMarket
//
//  Created by song on 2022/05/25.
//

import UIKit

final class ProductRegistrationView: UIView {
    private let imagesScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let imagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var imageView: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.image = UIImage(named: "sss")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let TextFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var productName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let productPrice: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품 가격"
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let currencySegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: CurrencyType.inventory)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    
    let productDiscountedPrice: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인 가격"
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let productStock: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고 수량"
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let productDescription: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        addsubView()
        constraintLayout()
        
        func addsubView() {
            addsubViews(imagesScrollView, TextFieldStackView, productDescription)
            imagesScrollView.addSubview(imagesStackView)
            imagesStackView.addArrangedsubViews(imageView)
            TextFieldStackView.addArrangedsubViews(productName, priceStackView, productDiscountedPrice, productStock)
            priceStackView.addArrangedsubViews(productPrice, currencySegmentControl)
        }

        func constraintLayout() {
            NSLayoutConstraint.activate([
                imagesScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                imagesScrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                imagesScrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                imagesScrollView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
                
                imagesStackView.topAnchor.constraint(equalTo: imagesScrollView.topAnchor),
                imagesStackView.bottomAnchor.constraint(equalTo: imagesScrollView.bottomAnchor),
                imagesStackView.leadingAnchor.constraint(equalTo: imagesScrollView.leadingAnchor),
                imagesStackView.trailingAnchor.constraint(equalTo: imagesScrollView.trailingAnchor),
                imagesStackView.heightAnchor.constraint(equalTo: imagesScrollView.heightAnchor),
                
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),

                TextFieldStackView.topAnchor.constraint(equalTo: imagesScrollView.bottomAnchor, constant: 10),
                TextFieldStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                TextFieldStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                TextFieldStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
                
                currencySegmentControl.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
                
                productDescription.topAnchor.constraint(equalTo: TextFieldStackView.bottomAnchor, constant: 10),
                productDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                productDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                productDescription.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}
