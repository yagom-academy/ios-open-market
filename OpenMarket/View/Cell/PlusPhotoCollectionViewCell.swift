//
//  PlusPhotoCollectionViewCell.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/27.
//

import UIKit

class PlusPhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PlusPhotoCollectionViewCell"

    @IBOutlet var currentPhotoCount: UILabel!
    var modalPresentDelegate: ModalPresentDelegate?
    var imageCollectionView: UICollectionView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func addPhoto(_ sender: Any) {
        ModalPhotoViewController.selectedImageCount = 0
        ItemPostViewController.images = [:]
        let modalPhotoViewController = ModalPhotoViewController()
        modalPhotoViewController.imageCollectionView = imageCollectionView
        self.modalPresentDelegate?.presentModalViewController(modalPhotoViewController, anitmated: true)
    }
    
}

protocol ModalPresentDelegate {
    func presentModalViewController(_:UIViewController,anitmated:Bool)
}

