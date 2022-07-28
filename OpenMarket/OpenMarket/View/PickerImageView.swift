//
//  PickerImageVIew.swift
//  OpenMarket
//
//  Created by 유한석 on 2022/07/28.
//

import UIKit

class PickerImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setFrame(at: 100)
    }
}
