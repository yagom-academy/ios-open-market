//
//  DetailProductView.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/12/08.
//

import UIKit

final class DetailProductView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupUI()
        registerCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: imageLayout)
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        collectionView.layer.borderWidth = 1
        collectionView.layer.cornerRadius = 10
        collectionView.layer.borderColor = UIColor.systemGray4.cgColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let imageLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        let collectionCellWidth = UIScreen.main.bounds.width * 0.9
        let collectionCellHeight = UIScreen.main.bounds.height * 0.4
        layout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellHeight)
        return layout
    }()
    
    private func registerCell() {
        collectionView.register(DetailProductCollectionViewCell.self, forCellWithReuseIdentifier: DetailProductCollectionViewCell.reuseIdentifier)
    }
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    private let productStockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let productSalePriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let pagingLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productPriceLabel,
                                                      productSalePriceLabel])
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var stockStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productStockLabel,
                                                      priceStackView])
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var productStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productNameLabel,
                                                      stockStackView])

        stackView.spacing = 10
        stackView.alignment = .top
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 10
        stackView.layer.borderColor = UIColor.systemGray4.cgColor
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func bindProductData(product: Product) {
        clearPriceLabel()
        self.productNameLabel.text = product.name
        self.productPriceLabel.text = String(product.currencyPrice)
        self.productSalePriceLabel.text = String(product.currencyBargainPrice)
        self.productStockLabel.text = String(product.stockDescription)
        self.descriptionTextView.text = product.description
        
        setupPriceLabel(product: product)
        setupStockLabelText()
    }
    
    func chanePagingLabel(num: Int, total: Int) {
        pagingLabel.text = "\(num)/\(total)"
    }
}

// MARK: - Constraints
extension DetailProductView {
    private func setupUI() {
        setupView()
        setupConstraints()
    }
    
    private func setupPriceLabel(product: Product) {
        if product.discountedPrice == Double.zero {
            productSalePriceLabel.isHidden = true
        } else {
            changePriceLabel()
        }
    }
    
    private func changePriceLabel() {
        productPriceLabel.textColor = .red
        productPriceLabel.applyStrikeThroughStyle()
    }
    
    private func clearPriceLabel() {
        productSalePriceLabel.isHidden = false
        productPriceLabel.textColor = .black
        productPriceLabel.attributedText = .none
    }
    
    private func setupStockLabelText() {
        if productStockLabel.text == "품절" {
            productStockLabel.textColor = .systemOrange
        } else {
            productStockLabel.textColor = .gray
        }
    }
    
    private func setupView() {
        self.addSubview(collectionView)
        self.addSubview(pagingLabel)
        self.addSubview(productStackView)
        self.addSubview(descriptionTextView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            collectionView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.4),
            collectionView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            pagingLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5),
            pagingLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            productStackView.topAnchor.constraint(equalTo: pagingLabel.bottomAnchor, constant: 5),
            productStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            productStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            descriptionTextView.topAnchor.constraint(equalTo: productStackView.bottomAnchor, constant: 10),
            descriptionTextView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            descriptionTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            descriptionTextView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}
