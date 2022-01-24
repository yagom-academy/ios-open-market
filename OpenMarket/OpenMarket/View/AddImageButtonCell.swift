//
//  AddButtonCell.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/21.
//

import UIKit

protocol AddImageCellDelegate: AnyObject {
    func addImagePressed()
}

final class AddImageButtonCell: UICollectionViewCell {
    weak var delegate: AddImageCellDelegate?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func addButtonWasPressed(_ sender: UIButton) {
        delegate?.addImagePressed()
    }
    
    func setDelegate(delegate: AddImageCellDelegate) {
        self.delegate = delegate
    }
}

extension AddImageButtonCell: IdentifiableView {}
