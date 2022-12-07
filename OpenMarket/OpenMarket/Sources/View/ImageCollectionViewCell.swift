//
//  OpenMarket - BaseProductView.swift
//  Created by Zhilly, Dragon. 22/12/02
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell, CellIdentifierInfo {
    @IBOutlet weak var image: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
    }
    
    func configureImage(url: URL?) {
        image.load(url: url)
    }
    
    func configureImage(imageFile: UIImage) {
        image.image = imageFile
    }
}
