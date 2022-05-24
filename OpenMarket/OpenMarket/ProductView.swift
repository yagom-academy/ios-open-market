//
//  ProductView.swift
//  OpenMarket
//
//  Created by 김태훈 on 2022/05/24.
//

import UIKit

class ProductView: UIView {
    let spaceView: UIView = UIView()
    
    lazy var mainStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return stackView
    }()
    
    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
         stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
         return stackView
    }()
    
    let nameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.addPadding()
        return textField
    }()
    
    let priceField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.addPadding()
        return textField
    }()
    
    let currencyField: UISegmentedControl = UISegmentedControl(items: Currency.allCases.map{ $0.rawValue } )
    let discountedPriceField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인가격"
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.addPadding()
        return textField
    }()
    
    let stockField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.addPadding()
        return textField
    }()
    
    let descriptionView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: 7, left: 5, bottom: 5, right: 5)
        return textView
    }()
    
    var collectionView: UICollectionView = {
       let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        collectionView
            .register(ImageRegisterCell.classForCoder(), forCellWithReuseIdentifier: "imageCell")
        priceStackView.addArrangedSubview(priceField)
        priceStackView.addArrangedSubview(currencyField)
        mainStackView.addArrangedSubview(collectionView)
        mainStackView.addArrangedSubview(nameField)
        mainStackView.addArrangedSubview(priceStackView)
        mainStackView.addArrangedSubview(discountedPriceField)
        mainStackView.addArrangedSubview(stockField)
        mainStackView.addArrangedSubview(descriptionView)
        mainScrollView.addSubview(mainStackView)
        mainScrollView.addSubview(spaceView)
        self.addSubview(mainScrollView)
        
        mainScrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mainScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true
        priceStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.20).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 15).isActive = true
        nameField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.05).isActive = true
        nameField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        nameField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        stockField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        stockField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        discountedPriceField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        discountedPriceField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        descriptionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        descriptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        descriptionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.466).isActive = true
        
        priceStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        priceStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        priceField.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05).isActive = true
        discountedPriceField.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05).isActive = true
        stockField.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05).isActive = true
        currencyField.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.25).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension UITextField {
    func addPadding() {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = padding
        self.leftViewMode = ViewMode.always
    }
}
