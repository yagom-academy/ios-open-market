//
//  PhotoCell.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/10.
//

import UIKit

class EnrollModifyPhotoCell: UICollectionViewCell {
    static let Identifier = String(describing: self)
    private let photoAlbumImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .green
        addSubview(photoAlbumImage)
        
        photoAlbumImage.frame = CGRect(x: 0, y: 0,
                                 width: contentView.frame.width,
                                 height: contentView.frame.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
