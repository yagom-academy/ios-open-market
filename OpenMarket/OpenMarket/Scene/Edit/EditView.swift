//
//  EditView.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/24.
//

import UIKit

final class EditView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
        setUpAttribute()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar(frame: CGRect(x: .zero, y: .zero, width: self.bounds.width, height: 50))
        navigationBar.items = [navigationBarItem]
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        return navigationBar
    }()
    
    let navigationBarItem: UINavigationItem = {
        let navigationBarItem = UINavigationItem(title: "")
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        
        navigationBarItem.leftBarButtonItem = cancelItem
        navigationBarItem.rightBarButtonItem = doneItem
        return navigationBarItem
    }()

    private let topScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                collectionView,
                productNameTextField,
                productPriceStackView,
                productDiscountedTextField,
                productStockTextField,
                productDescriptionTextView
            ]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: horizontalLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.preferredFont(forTextStyle: .subheadline)
        textField.adjustsFontForContentSizeCategory = true
        return textField
    }()
    
    private lazy var productPriceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productPriceTextField, productCurrencySegmentedControl])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    
    private let productPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.preferredFont(forTextStyle: .subheadline)
        textField.adjustsFontForContentSizeCategory = true
        return textField
    }()
    
    private let productCurrencySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["KRW", "USD"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private let productDiscountedTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인금액"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.preferredFont(forTextStyle: .subheadline)
        textField.adjustsFontForContentSizeCategory = true
        return textField
    }()
    
    private let productStockTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.preferredFont(forTextStyle: .subheadline)
        textField.adjustsFontForContentSizeCategory = true
        return textField
    }()
    
    private let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.setContentHuggingPriority(.defaultLow, for: .vertical)
        return textView
    }()
    
    private let horizontalLayout: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .absolute(140),
                                                     heightDimension: .fractionalHeight(1.0))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: "section-footer-element-kind", alignment: .bottom)
        section.boundarySupplementaryItems = [sectionFooter]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.scrollDirection = .horizontal
        return layout
    }()
    
    private func addSubviews() {
        topScrollView.addSubview(topStackView)
        addSubview(navigationBar)
        addSubview(topScrollView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            topScrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            topScrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            topScrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            topScrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            topScrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: topScrollView.widthAnchor),
            
            topStackView.topAnchor.constraint(equalTo: topScrollView.contentLayoutGuide.topAnchor),
            topStackView.bottomAnchor.constraint(equalTo: topScrollView.contentLayoutGuide.bottomAnchor),
            topStackView.leadingAnchor.constraint(equalTo: topScrollView.contentLayoutGuide.leadingAnchor, constant: 15),
            topStackView.trailingAnchor.constraint(equalTo: topScrollView.contentLayoutGuide.trailingAnchor, constant: -15),
            topStackView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.175)
        ])
    }
    
    private func setUpAttribute() {
        backgroundColor = .systemBackground
    }
    
    func setUpBarItem(title: String) {
        navigationBarItem.title = title
    }
}
                                            
