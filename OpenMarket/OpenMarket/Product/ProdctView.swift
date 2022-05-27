//
//  ProdctView.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/24.
//

import UIKit

private extension Constant.Image {
    static let keyboardDown = UIImage(systemName: "keyboard.chevron.compact.down")
}

class ProdctView: UIView {
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
        stackView.directionalLayoutMargins = .init(top: .zero, leading: 8, bottom: .zero, trailing: 8)
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
        
        textField.makeToolBar()
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
        
        textField.makeToolBar()
        textField.setContentHuggingPriority(.lowest, for: .horizontal)
        textField.placeholder = "상품가격"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let currencySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["KRW", "USD"])
        
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    let productDiscountCostTextField: UITextField = {
        let textField = UITextField()
        
        textField.makeToolBar()
        textField.placeholder = "할인금액"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let productStockTextField: UITextField = {
        let textField = UITextField()
        
        textField.makeToolBar()
        textField.placeholder = "재고수량"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        
        textView.makeToolBar()
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
    
    func configure(product: Product) {
        DispatchQueue.main.async { [self] in
            productNameTextField.text = product.name
            productCostTextField.text = "\(product.price ?? .zero)"
            productDiscountCostTextField.text = "\(product.discountedPrice ?? .zero)"
            productStockTextField.text = "\(product.stock ?? .zero)"
            productDescriptionTextView.text = product.description
            
            switch product.currency {
            case .KRW:
                currencySegmentedControl.selectedSegmentIndex = 0
            case .USD:
                currencySegmentedControl.selectedSegmentIndex = 1
            default:
                break
            }
        }
    }
    
    func makeEncodableModel() -> UploadProduct? {
        let price = productCostTextField.text.flatMap { Double($0) }
        let discountedPrice = productDiscountCostTextField.text.flatMap { Double($0) }
        let stock = productStockTextField.text.flatMap { Int($0) }
        
        return UploadProduct(name: productNameTextField.text,
                                 discountedPrice: discountedPrice,
                                 descriptions: productDescriptionTextView.text,
                                 price: price,
                                 stock: stock,
                                 currency: currencySegmentedControl.selectedSegmentIndex == 0 ? .KRW : .USD,
                                 secret: "password")
    }
}

// MARK: - UITextField

private extension UITextField {
    func makeToolBar() {
        let bar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let hiddenButton = UIBarButtonItem(image: Constant.Image.keyboardDown, style: .plain, target: self, action: #selector(keyboardHidden))
        bar.items = [space, hiddenButton]
        bar.sizeToFit()
        
        inputAccessoryView = bar
    }
    
    @objc private func keyboardHidden() {
        if isFirstResponder {
            resignFirstResponder()
        }
    }
}

// MARK: - UITextView

private extension UITextView {
    func makeToolBar() {
        let bar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let hiddenButton = UIBarButtonItem(image: Constant.Image.keyboardDown, style: .plain, target: self, action: #selector(keyboardHidden))
        bar.items = [space, hiddenButton]
        bar.sizeToFit()
        
        inputAccessoryView = bar
    }
    
    @objc private func keyboardHidden() {
        if isFirstResponder {
            resignFirstResponder()
        }
    }
}

// MARK: - CollectionView Layout

private extension UICollectionViewLayout {
    static let horizontalGrid: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }()
}
