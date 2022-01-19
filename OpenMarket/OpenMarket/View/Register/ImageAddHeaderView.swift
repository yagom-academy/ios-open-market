//
//  ImageAddHeaderView.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/18.
//

import UIKit

protocol ImageAddHeaderViewDelegate: AnyObject {
    func tappedAddButton()
}

class ImageAddHeaderView: UICollectionReusableView {
    static let identifier = "imageAddHeaderView"
    static let nibName = "ImageAddHeaderView"

    weak var delegate: ImageAddHeaderViewDelegate?
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var imageCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.layer.cornerRadius = 10
        addButton.layer.borderColor = UIColor.systemGray3.cgColor
        addButton.layer.borderWidth = 1
    }
    
    @IBAction func tappedAddButton(_ sender: UIButton) {
        delegate?.tappedAddButton()
    }
    
    func updateLabelText(imageCount: Int) {
        imageCountLabel.text = "\(imageCount) / 5"
    }
}
