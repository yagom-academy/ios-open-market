//
//  ItemImageCell.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/24.
//

import UIKit

final class ItemImageCell: UICollectionViewCell {
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var plusLabel: UILabel!
    
    func setItemImage() {
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.plusLabel.isHidden = true
        self.itemImageView.image = UIImage(systemName: "folder.fill")
    }
    
    func setPlusLabel() {
        self.backgroundColor = #colorLiteral(red: 0.854186415, green: 0.854186415, blue: 0.854186415, alpha: 1)
        self.plusLabel.isHidden = false
        self.itemImageView.image = nil
    }
}
