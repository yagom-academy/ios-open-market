//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/20.
//

import UIKit

final class ListCollectionViewCell: ItemCollectionViewCell {
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageStackView)
        contentView.addSubview(totalListStackView)
        
        setListStackView()
        setListConstraints()
        self.accessories = [.disclosureIndicator()]
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func prepareForReuse() {
        productPriceLabel.attributedText = nil
    }
    
    // MARK: Properties
   
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let upperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let downStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = Metric.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let totalListStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Metric.stackViewSpacing
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Method
    
    private func setListStackView() {
        imageStackView.addArrangedSubview(productThumbnailImageView)
        totalListStackView.addArrangedSubview(labelStackView)
        
        labelStackView.addArrangedSubview(upperStackView)
        labelStackView.addArrangedSubview(downStackView)
        
        upperStackView.addArrangedSubview(productNameLabel)
        upperStackView.addArrangedSubview(productStockQuntityLabel)
        
        downStackView.addArrangedSubview(productPriceLabel)
        downStackView.addArrangedSubview(bargainPriceLabel)
        
        productNameLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        productStockQuntityLabel.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        productPriceLabel.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
    }
    
    private func setListConstraints() {
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metric.listPositiveConstant),
            imageStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Metric.listNegativeConstant),
            imageStackView.widthAnchor.constraint(lessThanOrEqualToConstant: 80),
            imageStackView.heightAnchor.constraint(lessThanOrEqualToConstant: 80),
            imageStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metric.listPositiveConstant),
            
            totalListStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Metric.listNegativeConstant),
            totalListStackView.bottomAnchor.constraint(equalTo: imageStackView.bottomAnchor),
            totalListStackView.leadingAnchor.constraint(equalTo: imageStackView.trailingAnchor, constant: Metric.listPositiveConstant),
            totalListStackView.topAnchor.constraint(equalTo: imageStackView.topAnchor)
        ])
    }
}
