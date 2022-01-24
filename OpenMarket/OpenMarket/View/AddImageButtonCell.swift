//
//  AddButtonCell.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/21.
//

import UIKit

// MARK: - AddButtonPressedDelegate Protocol

protocol AddImageCellDelegate: AnyObject {
    func addImagePressed()
}

final class AddImageButtonCell: UICollectionViewCell {
    // MARK: - Properties
    
    weak var delegate: AddImageCellDelegate?
    
    // MARK: - Configure Methods
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - IBActions
    
    @IBAction func addButtonWasPressed(_ sender: UIButton) {
        delegate?.addImagePressed()
    }
    
    // MARK: - Setup Methods
    
    func setDelegate(delegate: AddImageCellDelegate) {
        self.delegate = delegate
    }
}

// MARK: - IdentifiableView

extension AddImageButtonCell: IdentifiableView {}
