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
        contentView.addSubview(totalListStackView)
        
        setListStackView()
        setListConstraints()
        
        self.accessories = [.disclosureIndicator()]
        self.contentView.layer.addBottomBorder()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        productPriceLabel.attributedText = nil
        productThumbnailImageView.image = nil
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
        totalListStackView.addArrangedSubview(productThumbnailImageView)
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
            productThumbnailImageView.widthAnchor.constraint(equalToConstant: Metric.imageSize),
            productThumbnailImageView.heightAnchor.constraint(equalToConstant: Metric.imageSize),
            totalListStackView.topAnchor.constraint(equalTo: productThumbnailImageView.topAnchor),
            totalListStackView.bottomAnchor.constraint(equalTo: productThumbnailImageView.bottomAnchor),
            totalListStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metric.stackViewSpacing),
            totalListStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Metric.listNegativeConstant)
        ])
    }
}

extension CALayer {
    func addBottomBorder() {
        let border = CALayer()
        let borderFrameSize = CGRect(x: 8, y: frame.height + 5, width: frame.width, height: 1)

        border.backgroundColor = UIColor.systemGray3.cgColor
        border.frame = borderFrameSize
        self.addSublayer(border)
    }
}
