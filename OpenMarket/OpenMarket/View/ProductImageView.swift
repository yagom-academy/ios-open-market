//
//  PickerImageVIew.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/28.
//

import UIKit

final class ProductImageView: UIImageView {

    init(sideLength: Int) {
        super.init(frame: .zero)
        setupImageView(with: sideLength)
    }
    
    init(width: Int, height: Int){
        super.init(frame: .zero)
        setupDetailImageView(width: width, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView(with sideLength: Int) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setFrame(at: sideLength)
    }
    
    private func setupDetailImageView(width: Int, height: Int) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        self.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
    }
}
