//
//  HorizontalCell.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/24.
//

import UIKit
final class ProductsHorizontalCell: UICollectionViewCell, BaseCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        makeConstraints()
    }
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func addSubviews() {
        contentView.addSubview(productImageView)
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func updateImage(imageInfo: ImageInfo) {
        if let image = UIImage(data: imageInfo.data) {
            productImageView.image = image
        }
    }
}
