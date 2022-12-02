//
//  RegistrationView.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/12/02.
//

import UIKit

class RegistrationView: UIView {
    var imageCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    let productNameTextField: CustomTextField = CustomTextField(placeHolder: "상품명")
    let productPriceTextField: CustomTextField = CustomTextField(placeHolder: "상품가격")
    let productDiscountPriceTextField: CustomTextField = CustomTextField(placeHolder: "할인금액")
    let stockTextField: CustomTextField = CustomTextField(placeHolder: "재고수량")
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = true
        textView.setContentHuggingPriority(.init(1), for: .vertical)
        textView.showsVerticalScrollIndicator = false
        
        return textView
    }()
    let fieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    }()
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    }()

    override init(frame: CGRect) {
        super .init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        [productNameTextField,
         productPriceTextField,
         productDiscountPriceTextField,
         stockTextField].forEach {
            fieldStackView.addArrangedSubview($0)
        }
         
        [fieldStackView,
         textView].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        [imageCollectionView, mainStackView].forEach {
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
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
}
