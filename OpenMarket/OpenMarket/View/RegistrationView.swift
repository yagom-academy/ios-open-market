//
//  RegistrationView.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/12/02.
//

import UIKit

final class RegistrationView: UIView {    
    private(set) var imageCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    private(set) var productNameTextField: CustomTextField = CustomTextField(placeholder: "상품명")
    private(set) var productPriceTextField: CustomTextField = CustomTextField(placeholder: "상품가격",
                                                                 keyboardType: .decimalPad )
    private(set) var productDiscountPriceTextField: CustomTextField = CustomTextField(placeholder: "할인금액",
                                                                         keyboardType: .decimalPad)
    private(set) var stockTextField: CustomTextField = CustomTextField(placeholder: "재고수량",
                                                          keyboardType: .numberPad)
    private(set) var priceStackView: CustomStackView = CustomStackView(spacing: 10)
    
    private(set) var currencySegmentControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Currency.krw.rawValue,
                                                          Currency.usd.rawValue])
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }()
    
    private(set) var textView: UITextView = {
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = true
        textView.setContentHuggingPriority(.init(1), for: .vertical)
        textView.showsVerticalScrollIndicator = false
        textView.font = .preferredFont(forTextStyle: .body )
        textView.layer.cornerRadius = 2
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        textView.text = "상세내용"
        textView.textColor = .systemGray3
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return textView
    }()
    
    private(set) var fieldStackView: CustomStackView = CustomStackView(axis: .vertical,
                                                          distribution: .fillEqually,
                                                          spacing: 10)
    private var mainStackView: CustomStackView = CustomStackView(axis: .vertical, spacing: 10)
    
    private(set) var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        [productPriceTextField,
         currencySegmentControl].forEach {
            priceStackView.addArrangedSubview($0)
        }
        
        [productNameTextField,
         priceStackView,
         productDiscountPriceTextField,
         stockTextField].forEach {
            fieldStackView.addArrangedSubview($0)
        }
        
        [imageCollectionView,
         fieldStackView,
         textView].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        mainScrollView.addSubview(mainStackView)
        self.addSubview(mainScrollView)
        
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(
                equalTo: mainStackView.topAnchor),
            imageCollectionView.leadingAnchor.constraint(
                equalTo: mainStackView.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(
                equalTo: mainStackView.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(
                equalTo: mainStackView.heightAnchor,multiplier: 0.25),
            
            fieldStackView.heightAnchor.constraint(
                equalTo: mainStackView.heightAnchor, multiplier: 0.25),
            
            mainStackView.leadingAnchor.constraint(
                equalTo: mainScrollView.frameLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(
                equalTo: mainScrollView.frameLayoutGuide.trailingAnchor),
            mainStackView.topAnchor.constraint(
                equalTo: mainScrollView.topAnchor),
            mainStackView.bottomAnchor.constraint(
                equalTo: mainScrollView.bottomAnchor),
            mainStackView.heightAnchor.constraint(
                equalTo: mainScrollView.frameLayoutGuide.heightAnchor),
            
            mainScrollView.frameLayoutGuide.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 10),
            mainScrollView.frameLayoutGuide.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -10),
            mainScrollView.frameLayoutGuide.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor),
            mainScrollView.frameLayoutGuide.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            mainScrollView.contentLayoutGuide.leadingAnchor.constraint(
                equalTo: mainScrollView.frameLayoutGuide.leadingAnchor),
            mainScrollView.contentLayoutGuide.trailingAnchor.constraint(
                equalTo: mainScrollView.frameLayoutGuide.trailingAnchor)
        ])
    }
}
