//
//  PlusPhotoCollectionViewCell.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/27.
//

import UIKit

class PlusPhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PlusPhotoCollectionViewCell"

    @IBOutlet var currentPhotoNumber: UILabel!
    var modalPresentDelegate: ModalPresentDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func addPhoto(_ sender: Any) {
        print("push")
        let modalPhotoViewController = ModalPhotoViewController()
        self.modalPresentDelegate?.presentModalViewController(modalPhotoViewController, anitmated: true)
    }
    
}

protocol ModalPresentDelegate {
    func presentModalViewController(_:UIViewController,anitmated:Bool)
}

