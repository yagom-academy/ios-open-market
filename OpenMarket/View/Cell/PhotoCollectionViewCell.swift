//
//  PhotoCollectionViewCell.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/27.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoCollectionViewCell"
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var backgroungView: UIView!
    var imageFileName = ""
    var isHighlight = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initData()
    }
    
    override func prepareForReuse() {
        initData()
    }
    
    func initData() {
        backgroungView.layer.borderWidth = 1.5
        backgroungView.layer.cornerRadius = 10
        backgroungView.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                if isHighlight {
                    backgroungView.layer.borderColor = UIColor.systemGray4.cgColor
                    ModalPhotoViewController.selectedImageCount -= 1
                    ItemPostViewController.images.removeValue(forKey:ModalPhotoViewController.selectedImageCount)
                    print(ItemPostViewController.images)
                    isHighlight = false
                } else {
                    guard ModalPhotoViewController.selectedImageCount < 5 else { return }
                    backgroungView.layer.borderColor = UIColor.orange.cgColor
                    ItemPostViewController.images[ModalPhotoViewController.selectedImageCount] = imageFileName
                    ModalPhotoViewController.selectedImageCount += 1
                    print(ItemPostViewController.images)
                    isHighlight = true
                }
            }
        }
    }
    
    
}
