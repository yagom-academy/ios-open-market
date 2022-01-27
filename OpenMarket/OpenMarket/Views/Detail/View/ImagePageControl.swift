//
//  ImagePageControl.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/25.
//

import UIKit

class ImagePageControl: UIPageControl {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpPageControl()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    private func setUpPageControl() {
        currentPage = 0
        pageIndicatorTintColor = .lightGray
        currentPageIndicatorTintColor = .black
        isHidden = true
    }
}
