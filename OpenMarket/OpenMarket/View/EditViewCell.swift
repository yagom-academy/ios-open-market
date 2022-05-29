//
//  EditViewCell.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/29.
//

import UIKit

final class EditViewCell: UICollectionViewCell {
    static let identifier = "EditViewCell"
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeProductImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        makeProductImage()
    }
    
    private func makeProductImage() {
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width)
    }
    
    func setImage(_ presenter: Presenter) {
        guard let productImages = presenter.images else {
            return
        }
        
        for image in productImages {
            guard let url = URL(string: image) else {
                return
            }
            
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            
            imageView.image = UIImage(data: data)
            contentView.addSubview(imageView)
        }
    }
}
