//
//  EnrollModifyPhotoSelectCell.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/11.
//

import UIKit

class EnrollModifyPhotoSeclectCell: UICollectionViewCell {
    static let identifier = "photoSelect"
    private let photoTotalNumber = 5
    private var photoSelectNumber = 0
    private let cameraImage = UIImage(systemName: "camera")
    private let photoSelectButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        photoSelectButton.setTitle("\(photoSelectNumber)/\(photoTotalNumber)", for: .normal)
        photoSelectButton.setTitleColor(.black, for: .normal)
        photoSelectButton.tintColor = .black
        photoSelectButton.setImage(cameraImage, for: .normal)
        contentView.addSubview(photoSelectButton)
        photoSelectButton.frame = CGRect(x: 0, y: 0,
                                 width: contentView.frame.width,
                                 height: contentView.frame.height)
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
