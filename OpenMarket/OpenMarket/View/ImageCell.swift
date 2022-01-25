//
//  ImageCell.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/20.
//

import UIKit

// MARK: - RemoveImageDelegate Protocol

protocol RemoveImageDelegate: AnyObject {
    func removeFromCollectionView(at index: Int)
}

 final class ImageCell: UICollectionViewCell {
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK: - Properties
    
    private var index: Int?
    weak var delegate: RemoveImageDelegate?
    
    // MARK: - Configure Methods
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with image: UIImage?, index: Int, delegate: RemoveImageDelegate) {
        setupImageView(with: image)
        self.index = index
        self.delegate = delegate
        setupDeleteButton()
    }
    
    private func setupImageView(with image: UIImage?) {
        imageView.image = image
        imageView.layer.cornerRadius = 10
    }
    
    private func setupDeleteButton() {
        self.deleteButton.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
    }
    
    // MARK: - Selector Method
    
    @objc func deleteImage() {
        guard let index = index else {
            return
        }
        delegate?.removeFromCollectionView(at: index)
    }
}

// MARK: - IdentifiableView

extension ImageCell: IdentifiableView {}
