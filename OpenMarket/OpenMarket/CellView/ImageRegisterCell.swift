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
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        
        return button
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpSubViewStructure()
        setUpLayoutConstraints()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubViewStructure()
        setUpLayoutConstraints()
        
    }
    
    func setUpSubViewStructure() {
        contentView.addSubview(imageView)
        contentView.addSubview(plusButton)
    }
    
    func setUpLayoutConstraints() {
        imageView.backgroundColor = .systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        plusButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        plusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}

