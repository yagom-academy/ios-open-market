//
//  RegistrationView.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/12/02.
//

import UIKit

class RegistrationView: UIView {
    var selectedImage: [UIImage] = []
    
    var imageCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    let productNameTextField: CustomTextField = CustomTextField(placeholder: "상품명")
    let productPriceTextField: CustomTextField = CustomTextField(placeholder: "상품가격",
                                                                 keyboardType: .decimalPad )
    let productDiscountPriceTextField: CustomTextField = CustomTextField(placeholder: "할인금액",
                                                                         keyboardType: .decimalPad)
    let stockTextField: CustomTextField = CustomTextField(placeholder: "재고수량",
                                                          keyboardType: .numberPad)
    let priceStackView: CustomStackView = CustomStackView(spacing: 10)
    let currencySegmentControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Currency.krw.rawValue,
                                                          Currency.usd.rawValue])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }()
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = true
        textView.setContentHuggingPriority(.init(1), for: .vertical)
        textView.showsVerticalScrollIndicator = false
        textView.font = .preferredFont(forTextStyle: .body )
        textView.layer.cornerRadius = 2
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.systemGray3.cgColor
      
        return textView
    }()
    let fieldStackView: CustomStackView = CustomStackView(axis: .vertical,
                                                          distribution: .fillEqually,
                                                          spacing: 10)
    let mainStackView: CustomStackView = CustomStackView(axis: .vertical, spacing: 10)


    override init(frame: CGRect) {
        super .init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
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
         
        [fieldStackView,
         textView].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        [imageCollectionView,
         mainStackView].forEach {
            self.addSubview($0)
        }

        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2),
            
            fieldStackView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.3),
            
            mainStackView.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40),
        ])
    }
}
