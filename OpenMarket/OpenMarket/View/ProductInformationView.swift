//
//  ProductInformationView.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/29.
//

import UIKit

final class ProductInformationView: UIView {
    let imagePickerCollectionView: ImagePickerCollectionView = ImagePickerCollectionView(frame: .zero, collectionViewLayout: .imagePicker)
    let nameTextField: NameTextField = NameTextField(minimumLength: 3, maximumLength: 100)
    let priceTextField: NumberTextField = NumberTextField(placeholder: "상품가격")
    let discountedPriceTextField: NumberTextField = NumberTextField(placeholder: "할인금액")
    let stockTextField: NumberTextField = NumberTextField(placeholder: "재고수량")
    let descriptionTextView: DescriptionTextView = DescriptionTextView(minimumLength: 10, maximumLength: 1000)
    let currencySegmentedControl: UISegmentedControl = {
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: ["KRW", "USD"])
        
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }()
    private let priceAndCurrencyStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let contentStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setUpViewsIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<Section, ViewContainer>) {
        imagePickerCollectionView.applySnapshot(snapshot)
    }
    
    private func setUpViewsIfNeeded() {
        backgroundColor = .white
        contentStackView.addArrangedSubview(imagePickerCollectionView)
        priceAndCurrencyStackView.addArrangedSubview(priceTextField)
        priceAndCurrencyStackView.addArrangedSubview(currencySegmentedControl)
        contentStackView.addArrangedSubview(nameTextField)
        contentStackView.addArrangedSubview(priceAndCurrencyStackView)
        contentStackView.addArrangedSubview(discountedPriceTextField)
        contentStackView.addArrangedSubview(stockTextField)
        contentStackView.addArrangedSubview(descriptionTextView)
        addSubview(contentStackView)
        
        let spacing: CGFloat = 10
        let safeArea: UILayoutGuide = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            imagePickerCollectionView.heightAnchor.constraint(equalToConstant: 160),
            contentStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: spacing),
            contentStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -spacing),
            contentStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: spacing),
            contentStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -spacing)
        ])
    }
}
