//
//  ItemCellImageView.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/21.
//

import UIKit

class ItemCellImageView: UIImageView {
    private var baseImage: UIImage?

    init(systemName: String) {
        super.init(image: UIImage(systemName: systemName))
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = .systemGray3
        contentMode = .scaleAspectFit
        baseImage = image
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func reset() {
        image = baseImage
    }
}
