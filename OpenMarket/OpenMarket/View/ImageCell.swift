//
//  ImageCell.swift
//  OpenMarket
//
//  Created by papri, Tiana on 25/05/2022.
//

import UIKit

class ImageCell: UICollectionViewCell {
    private let view: UIView = {
        let view = UIView()
        return view
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        
        func attribute() {
            button.setTitle("+", for: .normal)
            button.setTitleColor(UIColor.systemBlue, for: .normal)
            button.backgroundColor = .systemGray
        }
        
        attribute()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var isPlusButtonHidden: Bool {
        return plusButton.isHidden
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.isHidden = true
        configureHierarchy()
        plusButtonLayout()
        imageLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        view.addSubview(plusButton)
        view.addSubview(imageView)
        contentView.addSubview(view)
    }
    
    private func plusButtonLayout() {
        NSLayoutConstraint.activate([
            plusButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            plusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            plusButton.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            plusButton.widthAnchor.constraint(equalTo: plusButton.heightAnchor),
        ])
    }
    
    private func imageLayout() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
    
    func hidePlusButton() {
        plusButton.isHidden = true
        imageView.isHidden = false
    }
    
    func setImageView(with image: UIImage) {
        imageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.isHidden = true
        plusButton.isHidden = false
    }
}
