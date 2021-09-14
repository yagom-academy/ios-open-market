//
//  PhotoCell.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/10.
//

import UIKit

class EnrollModifyPhotoCell: UICollectionViewCell {
    static let identifier = String(describing: EnrollModifyPhotoCell.self)
    let photoAlbumImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    let deleteImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        photoAlbumImageSetup()
        deleteImageSetup()
    }
    
    private func photoAlbumImageSetup() {
        contentView.addSubview(photoAlbumImage)
        photoAlbumImage.layer.cornerRadius = 10
        photoAlbumImage.layer.borderWidth = 1
        photoAlbumImage.layer.borderColor = UIColor.black.cgColor
        photoAlbumImage.layer.masksToBounds = true
        photoAlbumImage.frame = CGRect(x: 0, y: 0,
                                       width: contentView.frame.width,
                                       height: contentView.frame.height)
    }
    
    private func deleteImageSetup() {
        contentView.addSubview(deleteImage)
        deleteImage.translatesAutoresizingMaskIntoConstraints = false
        deleteImage.image = UIImage(systemName: "multiply.circle.fill")
        deleteImage.tintColor = .black
        deleteImage.backgroundColor = .white
        deleteImage.layer.cornerRadius = 22
        NSLayoutConstraint.activate([
            deleteImage.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: 3),
            deleteImage.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: -3),
            deleteImage.widthAnchor.constraint(equalToConstant: 22),
            deleteImage.heightAnchor.constraint(equalToConstant: 22)
        ])
    }

    func configure(image: UIImage) {
        self.photoAlbumImage.image = image
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
