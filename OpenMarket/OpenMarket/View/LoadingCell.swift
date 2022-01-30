//
//  LoadingCell.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/01/30.
//

import UIKit

class LoadingCell: UICollectionViewCell {
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func start() {
        loadingIndicator.startAnimating()
    }
}
