//
//  GridCell.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/18.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    var productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var productName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var price: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var bargainPrice: UILabel = {
        let label = UILabel()
        label.tintColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var stock: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubViews() {
        self.addSubview(stackView)
        [productImage, productName, price, bargainPrice, stock].forEach { stackView.addArrangedSubview($0) }
    }
    
    func setStackViewConstraints() {
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
                                     stackView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor),
                                     stackView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor),
                                     stackView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor),
                                     stackView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
                                     stackView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor)])
    }
}
