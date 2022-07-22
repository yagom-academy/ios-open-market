//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/20.
//

import UIKit

class ListCollectionViewCell: ItemCollectionViewCell {
    
    // MARK: Inint
    
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
        productPrice.attributedText = nil
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
        stackView.spacing = 10
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
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Method
    
    private func setListStackView() {
        imageStackView.addArrangedSubview(productThumnail)
        totalListStackView.addArrangedSubview(labelStackView)
        
        labelStackView.addArrangedSubview(upperStackView)
        labelStackView.addArrangedSubview(downStackView)
        
        upperStackView.addArrangedSubview(productName)
        upperStackView.addArrangedSubview(productStockQuntity)
        
        downStackView.addArrangedSubview(productPrice)
        downStackView.addArrangedSubview(bargainPrice)
        
        productName.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        productStockQuntity.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        productPrice.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
    }
    
    private func setListConstraints() {
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageStackView.widthAnchor.constraint(lessThanOrEqualToConstant: 80),
            imageStackView.heightAnchor.constraint(lessThanOrEqualToConstant: 80),
            imageStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            
            totalListStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            totalListStackView.bottomAnchor.constraint(equalTo: imageStackView.bottomAnchor),
            totalListStackView.leadingAnchor.constraint(equalTo: imageStackView.trailingAnchor, constant: 5),
            totalListStackView.topAnchor.constraint(equalTo: imageStackView.topAnchor)
        ])
    }
}
