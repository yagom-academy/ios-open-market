//
//  ImageAddHeaderView.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/18.
//

import UIKit

class ImageAddHeaderView: UICollectionReusableView {
    static let identifier = "imageAddHeaderView"
    static let nibName = "ImageAddHeaderView"
    
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.layer.cornerRadius = 10
        addButton.layer.borderColor = UIColor.systemGray3.cgColor
        addButton.layer.borderWidth = 1
    }
    
}
