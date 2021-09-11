//
//  PhotoCell.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/10.
//

import UIKit

class EnrollModifyPhotoCell: UICollectionViewCell {
    static let identifier = "photo"
    private let photoAlbumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .yellow
        contentView.addSubview(photoAlbumImageView)
        photoAlbumImageView.frame = CGRect(x: 0, y: 0,
                                 width: contentView.frame.width,
                                 height: contentView.frame.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
