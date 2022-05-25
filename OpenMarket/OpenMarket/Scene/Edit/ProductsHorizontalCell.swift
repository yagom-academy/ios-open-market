//
//  HorizontalCell.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/24.
//

import UIKit
protocol CellDelegate: AnyObject {
    func addButtonTaped()
}

final class ProductsHorizontalCell: UICollectionViewCell, BaseCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
        setUpAtrribute()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        makeConstraints()
    }
    
    weak var delegate: CellDelegate?
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "plus")
        return imageView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func didTapAddButton() {
        delegate?.addButtonTaped()
    }
    
    private func addSubviews() {
        contentView.addSubview(productImageView)
        contentView.addSubview(addButton)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),
            
            addButton.topAnchor.constraint(equalTo: productImageView.topAnchor),
            addButton.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor),
        ])
    }
    
    private func setUpAtrribute() {
        addButton.addTarget(self, action: #selector(self.didTapAddButton), for: UIControl.Event.touchUpInside)
    }
    
    func updateImage(imageInfo: ImageInfo) {
        if let image = UIImage(data: imageInfo.data) {
            productImageView.image = image
        }
    }
}
