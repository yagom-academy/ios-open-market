//
//  RegistrationViewCell.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/24.
//

import UIKit

final class RegistrationViewCell: UICollectionViewCell {
    static let identifier = "RegistrationViewCell"
    let imageView = UIImageView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.addSubview(label)
        makeProductImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage()
        makeProductImage()
    }
    
    func makeProductImage() {
        label.text = "+"
        label.textColor = .systemBlue
        
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width)
        imageView.backgroundColor = .systemGray3
        imageView.isUserInteractionEnabled = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 20),
            label.heightAnchor.constraint(equalTo: label.widthAnchor)
        ])
    }
}
