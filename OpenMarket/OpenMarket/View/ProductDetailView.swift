//
//  ProductDetailView.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/24.
//

import UIKit

enum Currency: String {
    case KRW
    case USD
}

enum PlaceHolder: String {
    case productName = "상품명"
    case price = "상품가격"
    case discountedPrice = "할인금액"
    case stock = "재고수량"
}

final class ProductDetailView: UIView {
    private lazy var entireStackView = makeStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 20)
    private lazy var productInfoStackView = makeStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 10)
    private lazy var priceStackView = makeStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 3)
    let priceTextField = UITextField()
    let segmentedContol = UISegmentedControl(items: [Currency.KRW.rawValue, Currency.USD.rawValue])
    let productNameTextField = UITextField()
    let discountedPriceTextField = UITextField()
    let stockTextField = UITextField()
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        
        textView.isEditable = true
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.addSubview(entireStackView)
        entireStackView.addArrangedSubview([productInfoStackView, descriptionTextView])
        productInfoStackView.addArrangedSubview([productNameTextField, priceStackView, discountedPriceTextField, stockTextField])
        priceStackView.addArrangedSubview([priceTextField, segmentedContol])
        
        configureEntireStackViewLayout()
        configureProductInfoStackView()
        configurePriceStackView()
    }
    
    func configurePriceStackView() {
        priceTextField.borderStyle = .roundedRect
        priceTextField.placeholder = PlaceHolder.price.rawValue
        priceTextField.keyboardType = .numberPad
        segmentedContol.selectedSegmentIndex = 0
        
        segmentedContol.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        priceTextField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        segmentedContol.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func configureProductInfoStackView() {
        productNameTextField.borderStyle = .roundedRect
        productNameTextField.placeholder = PlaceHolder.productName.rawValue
        
        discountedPriceTextField.borderStyle = .roundedRect
        discountedPriceTextField.placeholder = PlaceHolder.discountedPrice.rawValue
        discountedPriceTextField.keyboardType = .numberPad
        
        stockTextField.borderStyle = .roundedRect
        stockTextField.placeholder = PlaceHolder.stock.rawValue
        stockTextField.keyboardType = .numberPad
    }
    
    func configureEntireStackViewLayout() {
        entireStackView.translatesAutoresizingMaskIntoConstraints = false
        productInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.entireStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.entireStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.entireStackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.entireStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.entireStackView.heightAnchor.constraint(equalTo: self.heightAnchor),
        ])
    }
}

extension ProductDetailView {
    private func makeStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        
        return stackView
    }
}
