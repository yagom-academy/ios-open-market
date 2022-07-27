//
//  AddProductViewCell.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/27.
//

import UIKit

final class AddProductCollectionViewCell: UICollectionViewCell {
    static let id = "ProductCell"

    let productImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray5
        return button
    }()

    private func arrangeSubView() {
        self.contentView.addSubview(productImageButton)

        NSLayoutConstraint.activate([
            productImageButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            productImageButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            productImageButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            productImageButton.topAnchor.constraint(equalTo: self.contentView.topAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        arrangeSubView()
    }
}
