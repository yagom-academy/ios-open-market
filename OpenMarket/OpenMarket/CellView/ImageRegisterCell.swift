//
//  ImageRegisterCell.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/23.
//

import UIKit

final class ImageRegisterCell: UICollectionViewCell {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpSubViewStructure()
        setUpLayoutConstraints()
        setImageForCell()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubViewStructure()
        setUpLayoutConstraints()
        setImageForCell()
    }
    
    func setUpSubViewStructure() {
        contentView.addSubview(imageView)
    }
    
    func setUpLayoutConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        //imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        //imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    func setImageForCell() {
        imageView.image = UIImage(named: "macmini")
    }
}
