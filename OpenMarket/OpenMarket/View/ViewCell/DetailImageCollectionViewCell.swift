//
//  DetailImageCollectionViewCell.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/08/02.
//

import UIKit

class DetailImageCollectionViewCell: UICollectionViewCell {
    let imageView: SessionImageView = {
        let image = SessionImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let imageNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        arrangeSubView()
    }
    
//    func configureCell(with item: DetailProduct) {
//        if let cachedImage = ImageCacheManager.shared.object(forKey: NSString(string: )) {
//            imageView.image = cachedImage
//        } else {
//            imageView.configureImage(url: item.productImage, cell, indexPath, collectionView)
//        }
//    }
    
    private func arrangeSubView() {
        entireStackView.addArrangedSubview(imageView)
        entireStackView.addArrangedSubview(imageNumberLabel)
        
        contentView.addSubview(entireStackView)
        
        NSLayoutConstraint.activate([
            entireStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            entireStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            entireStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            entireStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
