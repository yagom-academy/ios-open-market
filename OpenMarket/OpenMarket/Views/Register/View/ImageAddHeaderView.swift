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
    @IBOutlet weak var imageCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.layer.cornerRadius = 10
        addButton.layer.borderColor = UIColor.systemGray3.cgColor
        addButton.layer.borderWidth = 1
        setUpNotificationCenter()
    }
    
    @IBAction func tappedAddButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: .addButton, object: nil)
    }
    
    @objc func updateLabelText(_ notification: Notification) {
        guard let imageCount = notification.object as? Int else {
            return
        }
        imageCountLabel.text = "\(imageCount) / 5"
    }
    
    private func setUpNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateLabelText),
            name: .editImageCountLabel, object: nil
        )
    }
}
