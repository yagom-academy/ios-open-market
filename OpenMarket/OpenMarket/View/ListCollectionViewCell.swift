//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by dhoney96 on 2022/07/20.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    private let horizontalStackView = UIStackView()
    var accessoryView = UIImageView()
    let titleLabel = UILabel()
    let stockLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHorizontalStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureHorizontalStackView() {
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalStackView.distribution = .fill
        horizontalStackView.axis = .horizontal
        
        titleLabel.textAlignment = .left
        stockLabel.textAlignment = .right
        stockLabel.tintColor = .systemGray
        
        let image = UIImageView(image: UIImage(systemName: "chevron.right"))
        accessoryView = image
        accessoryView.tintColor = .systemGray
        
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(titleLabel)
        horizontalStackView.addArrangedSubview(stockLabel)
        horizontalStackView.addArrangedSubview(accessoryView)
        
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),

            accessoryView.heightAnchor.constraint(equalToConstant: 15),
            accessoryView.widthAnchor.constraint(equalToConstant: 15),
            accessoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            stockLabel.trailingAnchor.constraint(equalTo: accessoryView.leadingAnchor, constant: -5)
        ])
    }
}
