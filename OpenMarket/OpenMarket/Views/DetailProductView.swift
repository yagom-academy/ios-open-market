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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let imageLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionCellWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        return layout
    }()
    
    private func registerCell() {
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
    }
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
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
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let productSalePriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.cornerRadius = 10
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productPriceLabel,
                                                      productSalePriceLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .trailing
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var stockStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productStockLabel,
                                                      priceStackView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .trailing
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var productStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productNameLabel,
                                                      stockStackView])
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func bindProductData(product: Product) {
        self.productNameLabel.text = product.name
        self.productPriceLabel.text = String(product.currencyPrice)
        self.productSalePriceLabel.text = String(product.currencyBargainPrice)
        self.productStockLabel.text = String(product.stockDescription)
        self.descriptionTextView.text = product.description
    }
}

// MARK: - Constraints
extension DetailProductView {
    func setupUI() {
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        self.addSubview(collectionView)
        self.addSubview(productStackView)
        self.addSubview(descriptionTextView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 1),
            collectionView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            productStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            productStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            productStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            
            descriptionTextView.topAnchor.constraint(equalTo: productStackView.bottomAnchor, constant: 30),
            descriptionTextView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            descriptionTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            descriptionTextView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}
