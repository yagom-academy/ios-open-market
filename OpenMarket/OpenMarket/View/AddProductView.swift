//
//  AddProductView.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/27.
//

import UIKit

final class AddProductView: UIView {
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5.0
        layout.itemSize = CGSize(width: 120, height: 120)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        view.register(AddProductCollectionViewCell.self, forCellWithReuseIdentifier: AddProductCollectionViewCell.id)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let productNameTextfield: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "상품명"
        textField.font = .preferredFont(forTextStyle: .caption1)
        textField.keyboardType = .default
        textField.adjustsFontForContentSizeCategory = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let priceTextfield: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "상품가격"
        textField.font = .preferredFont(forTextStyle: .caption1)
        textField.keyboardType = .numberPad
        textField.adjustsFontForContentSizeCategory = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let discountedPriceTextfield: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "할인금액"
        textField.font = .preferredFont(forTextStyle: .caption1)
        textField.keyboardType = .numberPad
        textField.adjustsFontForContentSizeCategory = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let stockTextfield: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "재고수량"
        textField.font = .preferredFont(forTextStyle: .caption1)
        textField.keyboardType = .numberPad
        textField.adjustsFontForContentSizeCategory = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UIKit.UISegmentedControl(items: [Currency.krw.rawValue, Currency.usd.rawValue])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .caption1)
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func arrangeSubView() {
        self.backgroundColor = .systemBackground
        
        priceStackView.addArrangedSubview(priceTextfield)
        priceStackView.addArrangedSubview(segmentedControl)
        
        infoStackView.addArrangedSubview(productNameTextfield)
        infoStackView.addArrangedSubview(priceStackView)
        infoStackView.addArrangedSubview(discountedPriceTextfield)
        infoStackView.addArrangedSubview(stockTextfield)
        
        entireStackView.addArrangedSubview(collectionView)
        entireStackView.addArrangedSubview(infoStackView)
        entireStackView.addArrangedSubview(descriptionTextView)
        
        self.addSubview(entireStackView)
        
        NSLayoutConstraint.activate([
            entireStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            entireStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            entireStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            
            collectionView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
            segmentedControl.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            infoStackView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2)
        ])
        let stackBottomConstraint = entireStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8)
            stackBottomConstraint.priority = .defaultHigh
            stackBottomConstraint.isActive = true
    }
    
    func createParam() -> Param? {
        guard let name = productNameTextfield.text,
              let price = priceTextfield.text,
              var discountedPrice = discountedPriceTextfield.text,
              var stock = stockTextfield.text,
              let descriptionText = descriptionTextView.text else { return nil }

        var currency = ""
    
        if segmentedControl.selectedSegmentIndex == 0 {
            currency = Currency.krw.rawValue
        } else {
            currency = Currency.usd.rawValue
        }
        
        if discountedPrice == "" {
            discountedPrice = "0"
        }

        if stock == "" {
            stock = "0"
        }
        
        let param = Param(productName: name, price: price, discountedPrice: discountedPrice, currency: currency, stock: stock, description: descriptionText)
        
        return param
    }
    
    func configure(data: Param) {
        productNameTextfield.text = data.productName
        priceTextfield.text = data.price
        discountedPriceTextfield.text = data.discountedPrice
        stockTextfield.text = data.stock
        descriptionTextView.text = data.description
        
        if data.currency == Currency.krw.rawValue {
            segmentedControl.selectedSegmentIndex = 0
        } else {
            segmentedControl.selectedSegmentIndex = 1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        arrangeSubView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

