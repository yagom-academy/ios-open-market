//
//  ProductDetailView.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/08/09.
//

import UIKit

final class ProductDetailView: UIView {
    // MARK: - properties
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let pageCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .footnote)
        
        return label
    }()
    
    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .top
        
        return stackView
    }()
    
    private let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .trailing
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        return label
    }()
    
    private let descriptionScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setUpSubViews()
        setUpStackViewConstraints()
    }
    
    private func setUpSubViews() {
        self.addSubview(totalStackView)
        [pageCountLabel, leftStackView, descriptionScrollView].forEach
        {
            totalStackView.addArrangedSubview($0)
        }
        
        [productNameLabel, rightStackView].forEach
        {
            leftStackView.addArrangedSubview($0)
        }
        
        [stockLabel, priceLabel].forEach
        {
            rightStackView.addArrangedSubview($0)
        }
        
        descriptionScrollView.addSubview(descriptionLabel)
    }
    
    private func setUpStackViewConstraints() {
        NSLayoutConstraint.activate(
            [
                totalStackView.topAnchor.constraint(equalTo: self.topAnchor),
                totalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                totalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                totalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate(
            [
                descriptionScrollView.frameLayoutGuide.widthAnchor.constraint(equalTo: totalStackView.widthAnchor),
                descriptionScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                descriptionScrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                descriptionScrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        
        NSLayoutConstraint.activate(
            [
                descriptionLabel.leadingAnchor.constraint(equalTo: descriptionScrollView.leadingAnchor),
                descriptionLabel.trailingAnchor.constraint(equalTo: descriptionScrollView.trailingAnchor),
                descriptionLabel.topAnchor.constraint(equalTo: descriptionScrollView.contentLayoutGuide.topAnchor),
                descriptionLabel.bottomAnchor.constraint(equalTo: descriptionScrollView.contentLayoutGuide.bottomAnchor)
            ])
    }
    
    func setupViewItems(_ product: ProductDetail) {
        productNameLabel.text = product.name
        stockLabel.attributedText = product.makeStockText()
        priceLabel.attributedText = product.makePriceText()
        descriptionLabel.text = product.description
    }
    
    func setupPageCountLabel(text: String) {
        pageCountLabel.text = text
    }
}
