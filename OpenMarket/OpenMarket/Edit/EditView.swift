//
//  EditView.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/24.
//

import UIKit

class EditView: UIView {
    
    private lazy var baseStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [collectionView,
                                                       productNameTextField,
                                                       productCostStackView,
                                                       productDiscountCostTextField,
                                                       productStockTextField,
                                                       productDescriptionTextView])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.directionalLayoutMargins = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .horizontalGrid)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    let productNameTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "상품명"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var productCostStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productCostTextField, currencySegmentedControl])
        
        stackView.spacing = 8
        return stackView
    }()
    
    let productCostTextField: UITextField = {
        let textField = UITextField()
        
        textField.setContentHuggingPriority(.lowest, for: .horizontal)
        textField.placeholder = "상품가격"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let currencySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["KRW", "USD"])
        
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    let productDiscountCostTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "할인금액"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let productStockTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "재고수량"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .systemBackground
    }
    
    private func configureLayout() {
        addSubview(baseStackView)
        
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            baseStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            baseStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            baseStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2)
        ])
    }
}

private extension UICollectionViewLayout {
    static let horizontalGrid: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/5), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }()
}
