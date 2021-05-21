//
//  ItemCellImageView.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/21.
//

import UIKit

class ItemCellImageView: UIImageView {
    init(systemName: String) {
        super.init(image: UIImage(systemName: systemName))
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
        layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
