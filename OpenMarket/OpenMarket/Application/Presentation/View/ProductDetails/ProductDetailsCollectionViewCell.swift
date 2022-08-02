//
//  ProductDetailsCollectionViewCell.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

final class ProductDetailsCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.alignment = .fill
        
        return stackView
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let productStockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        
        return label
    }()
    
    private var viewModel: ProductDetailsViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productImageView.image = nil
        productStockLabel.text = nil
    }
    
    private func configureStackView() {
        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubview(productImageView)
        rootStackView.addArrangedSubview(productStockLabel)
        
        productImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            rootStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            productImageView.heightAnchor.constraint(equalTo: rootStackView.heightAnchor, multiplier: 0.9),
            productStockLabel.heightAnchor.constraint(equalTo: rootStackView.heightAnchor, multiplier: 0.1),
        ])
    }
    
    func configureUI(data: UIImage, currentImageNumber: Int, totalImageNumber: Int) {
        productImageView.image = data
        productStockLabel.text = "\(currentImageNumber)/\(totalImageNumber)"
    }
}
