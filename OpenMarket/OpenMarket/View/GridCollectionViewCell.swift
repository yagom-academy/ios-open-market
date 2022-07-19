//
//  GridCell.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/18.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell {
    // MARK: - properties
    
    var productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var productName: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var price: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var stock: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 5
        
        return stackView
    }()
    
    // MARK: - initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - functions
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    private func setSubViews() {
        self.contentView.addSubview(productImage)
        self.contentView.addSubview(stackView)
        [productName, price, stock].forEach { stackView.addArrangedSubview($0) }
    }
    
    private func setStackViewConstraints() {
        NSLayoutConstraint.activate(
            [productImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
             productImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
             productImage.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
             productImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.5)])
        
        NSLayoutConstraint.activate(
            [stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
             stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
             stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)])
    }
}
