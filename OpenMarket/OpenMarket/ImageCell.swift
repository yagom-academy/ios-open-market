//
//  ImageCell.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/12/01.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    var isNotEmpty: Bool {
        return productImageView.image != nil
    }
    
    private let plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus")
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let productImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(productImageView)
        contentView.addSubview(plusImageView)
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            plusImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            plusImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            plusImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
            plusImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
        ])
    }
    
    func updateImage(image: UIImage?) {
        guard let dataSize = image?.jpegData(compressionQuality: 0.9)?.count else {
            return
        }
        let kbSize = Double(dataSize / 1024)
        plusImageView.isHidden = true
        
        if kbSize > 300 {
            let scale = floor(sqrt(300 / kbSize) * 10) / 10
            productImageView.image = image?.resize(scale)
        } else {
            productImageView.image = image
        }
    }
    
    func resetCell() {
        plusImageView.isHidden = false
        productImageView.image = nil
    }
    
    func productImageData() -> Data? {
        return productImageView.image?.jpegData(compressionQuality: 0.9)
    }
}
