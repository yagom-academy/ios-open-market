//
//  AddButtonCell.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/21.
//

import UIKit

// MARK: - AddImageCellDelegate Protocol

protocol AddImageCellDelegate: AnyObject {
    func addImageButtonTapped()
}

final class AddImageButtonCell: UICollectionViewCell {
    // MARK: - Properties
    
    weak var delegate: AddImageCellDelegate?
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: - Configure Methods
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - IBActions
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        delegate?.addImageButtonTapped()
    }
    
    // MARK: - Setup Methods
    
    func setup(delegate: AddImageCellDelegate) {
        self.delegate = delegate
        setupAddButton()
    }
    
    private func setupAddButton() {
        addButton.layer.cornerRadius = 10
    }
}

// MARK: - IdentifiableView

extension AddImageButtonCell: IdentifiableView {}
