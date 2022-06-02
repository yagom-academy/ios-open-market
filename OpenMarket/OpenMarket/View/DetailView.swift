//
//  DetailView.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/06/02.
//

import UIKit

final class DetailView: UIView {
    let numberFormatter: NumberFormatter = NumberFormatter()
    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return scrollView
    }()
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return stackView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(for: .title3, weight: .semibold)
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .systemGray
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(for: .body, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    
    let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = .preferredFont(for: .body, weight: .semibold)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.decelerationRate = .fast
        collectionView.contentInsetAdjustmentBehavior = .never
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupSubviewStructures()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupSubviewStructures() {
        
        informationStackView.addArrangedSubview(nameLabel)
        informationStackView.addArrangedSubview(stockLabel)
        
        mainStackView.addArrangedSubview(collectionView)
        mainStackView.addArrangedSubview(informationStackView)
        
        mainStackView.addArrangedSubview(priceLabel)
        mainStackView.addArrangedSubview(bargainPriceLabel)
        mainStackView.addArrangedSubview(descriptionLabel)
        mainScrollView.addSubview(mainStackView)
        self.addSubview(mainScrollView)
        
    }
    
    func setupLayoutConstraints() {
        mainScrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mainScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        mainScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        mainScrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        mainScrollView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        mainStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor).isActive = true
        mainStackView.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor).isActive = true
        
        collectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45).isActive = true
        
        informationStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor).isActive = true
        informationStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: informationStackView.leadingAnchor).isActive = true
        stockLabel.trailingAnchor.constraint(equalTo: informationStackView.trailingAnchor).isActive = true
        
        priceLabel.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
        bargainPriceLabel.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
    }
    
    func configureContents(product: Product?) {
        guard let product = product else {
            return
        }
        
        guard let currency = product.currency?.rawValue else {
            return
        }
        
        nameLabel.text = product.name
        stockLabel.text = "남은 수량 : \(numberFormatter.numberFormatString(for: Double(product.stock)))"
        priceLabel.text = "\(currency) \(numberFormatter.numberFormatString(for:product.price))"
        
        if product.discountedPrice != .zero {
            guard let price = priceLabel.text else {
                return
            }
            priceLabel.textColor = .red
            priceLabel.attributedText = setTextAttribute(of: price, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            bargainPriceLabel.text = "\(currency) \(numberFormatter.numberFormatString(for:product.bargainPrice))"
        }
        
        
        descriptionLabel.text = product.description
    }
    
    private func setTextAttribute(of target: String, attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: target)
        attributedText.addAttributes(attributes, range: (target as NSString).range(of: target))
        
        return attributedText
    }
}
