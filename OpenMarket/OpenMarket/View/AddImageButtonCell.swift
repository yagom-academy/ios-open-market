//
//  AddButtonCell.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/21.
//

import UIKit

protocol AddImageCellDelegate {
    func addImagePressed(by cell: AddImageButtonCell)
}

final class AddImageButtonCell: UICollectionViewCell {
    weak var delegate: ProductDetailsViewController?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func addButtonWasPressed(_ sender: UIButton) {
        delegate?.addImagePressed(by: self)
    }
}

extension AddImageButtonCell: IdentifiableView {}
