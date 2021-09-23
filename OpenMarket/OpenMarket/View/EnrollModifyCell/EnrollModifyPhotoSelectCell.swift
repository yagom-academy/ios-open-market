//
//  EnrollModifyPhotoSelectCell.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/11.
//

import UIKit

class EnrollModifyPhotoSeclectCell: UICollectionViewCell {
    static let identifier = String(describing: EnrollModifyPhotoSeclectCell.self)
    private let cameraImage = UIImage(systemName: "camera")
    private let photoTotalNumber = 5
    private var photoSelectNumber = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    private func setup() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func configure(photoSelectButton: UIButton) {
        photoSelectButton.setTitle(
            "\(photoSelectNumber)/\(photoTotalNumber)", for: .normal)
        photoSelectButton.setImage(cameraImage, for: .normal)
        photoSelectButton.setTitleColor(.black, for: .normal)
        photoSelectButton.tintColor = .black
        contentView.addSubview(photoSelectButton)
        photoSelectButton.frame = CGRect(x: 0, y: 0,
                                         width: contentView.frame.width,
                                         height: contentView.frame.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
