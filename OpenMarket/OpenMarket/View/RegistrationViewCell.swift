//
//  RegistrationViewCell.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/24.
//

import UIKit

final class RegistrationViewCell: UICollectionViewCell {
    static let identifier = "RegistrationViewCell"
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        makeProductImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(button)
        makeProductImage()
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        button.setImage(nil, for: .normal)
        makeProductImage()
    }
    
    func makeProductImage() {
        button.setTitle("+", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray3
        button.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width)
    }
}
