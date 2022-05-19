//
//  CALayer+.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/18.
//

import UIKit

extension CALayer {
    func addSeparator() {
        let separator = CALayer()
        
        separator.frame = CGRect.init(x: 10, y: frame.height - 0.5, width: frame.width, height: 0.5)
        
        separator.backgroundColor = UIColor.systemGray2.cgColor
        self.addSublayer(separator)
    }
}
