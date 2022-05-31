//
//  ProductRegistrationView.swift
//  OpenMarket
//
//  Created by song on 2022/05/25.
//

import UIKit

fileprivate enum Const {
  static let addImage = "sss"
    
    enum Product {
        static let name = "상품명"
        static let price = "상품가격"
        static let discountedPrice = "할인가격"
        static let stock = "재고수량"
    }
}

final class ManagementView: UIView {
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
    
    var addImageView: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.image = UIImage(named: Const.addImage)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Const.Product.name
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
    
    let priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Const.Product.price
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: CurrencyType.inventory)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    
    let discountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Const.Product.discountedPrice
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let stockTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Const.Product.stock
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let descriptionTextView: UITextView = {
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
}


// MARK: - Layout

extension ManagementView {
    
    private func setupView() {
        
        addsubView()
        constraintLayout()
        
        func addsubView() {
            addsubViews(imagesScrollView, textFieldStackView, descriptionTextView)
            imagesScrollView.addSubview(imagesStackView)
            imagesStackView.addArrangedsubViews(addImageView)
            textFieldStackView.addArrangedsubViews(nameTextField, priceStackView, discountedPriceTextField, stockTextField)
            priceStackView.addArrangedsubViews(priceTextField, segmentControl)
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
                
                addImageView.widthAnchor.constraint(equalTo: addImageView.heightAnchor),
                
                textFieldStackView.topAnchor.constraint(equalTo: imagesScrollView.bottomAnchor, constant: 10),
                textFieldStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                textFieldStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                textFieldStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
                
                segmentControl.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
                
                descriptionTextView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 10),
                descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}
