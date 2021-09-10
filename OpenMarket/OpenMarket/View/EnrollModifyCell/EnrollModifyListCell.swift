//
//  EnrollModifyListCell.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/10.
//

import UIKit

class EnrollModifyListCell: UICollectionViewCell {
    static let Identifier = "list"
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
        self.backgroundColor = .red
        addSubview(photoAlbumImage)
        
        photoAlbumImage.frame = CGRect(x: 0, y: 0,
                                 width: contentView.frame.width,
                                 height: contentView.frame.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
