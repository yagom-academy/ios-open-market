//
//  ProductDetailView.swift
//  OpenMarket
//
//  Created by LeeChiheon on 2022/07/26.
//

import UIKit

class ProductDetailView: UIView {

    // MARK: - Properties
    
    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let itemImageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    let itemNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        return textField
    }()
    
    let itemPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.keyboardType = .numberPad
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        return textField
    }()
    
    let currencySegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["KRW", "USD"])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    let currencyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    let itemSaleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인금액"
        textField.keyboardType = .numberPad
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        return textField
    }()
    
    let itemStockTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.keyboardType = .numberPad
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        return textField
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemGray3
        return button
    }()
    
    let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.text = "테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트\n테스트"
        return textView
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        configureLayoutContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addToScrollView(of image: UIImage, viewController: ProductsDetailViewController) {
        let newImageView = UIImageView(image: image)
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        newImageView.widthAnchor.constraint(equalTo: newImageView.heightAnchor).isActive = true
        newImageView.isUserInteractionEnabled = true
        
        imageStackView.insertArrangedSubview(newImageView, at: imageStackView.arrangedSubviews.count - 1)
    }
}

extension ProductDetailView {
    private func addViews() {
        addSubview(mainScrollView)
        
        mainScrollView.addSubview(itemImageScrollView)
        mainScrollView.addSubview(textFieldStackView)
        mainScrollView.addSubview(descriptionTextView)
        
        itemImageScrollView.addSubview(imageStackView)
        
        imageStackView.addArrangedSubview(button)
        
        textFieldStackView.addArrangedSubview(itemNameTextField)
        textFieldStackView.addArrangedSubview(currencyStackView)
        textFieldStackView.addArrangedSubview(itemSaleTextField)
        textFieldStackView.addArrangedSubview(itemStockTextField)
        
        currencyStackView.addArrangedSubview(itemPriceTextField)
        currencyStackView.addArrangedSubview(currencySegmentControl)
    }
    
    private func configureLayoutContraints() {
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            mainScrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            itemImageScrollView.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 15),
            itemImageScrollView.bottomAnchor.constraint(equalTo: textFieldStackView.topAnchor, constant: -15),
            itemImageScrollView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            itemImageScrollView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor, multiplier: 0.2)
        ])

        NSLayoutConstraint.activate([
            imageStackView.leadingAnchor.constraint(equalTo: itemImageScrollView.contentLayoutGuide.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: itemImageScrollView.contentLayoutGuide.trailingAnchor),
            imageStackView.centerYAnchor.constraint(equalTo: itemImageScrollView.centerYAnchor),
            imageStackView.heightAnchor.constraint(equalTo: itemImageScrollView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: button.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textFieldStackView.bottomAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: -15),
            textFieldStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            textFieldStackView.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            currencySegmentControl.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3)
        ])
        
        NSLayoutConstraint.activate([
            descriptionTextView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor),
            descriptionTextView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            descriptionTextView.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor)
        ])
        
    }
}
