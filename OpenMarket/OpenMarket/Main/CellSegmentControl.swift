//
//  CellSegmentControl.swift
//  OpenMarket
//
//  Created by 이시원 on 2022/05/17.
//

import Foundation
import UIKit

class CellSegmentControl: UISegmentedControl {
    override init(items: [Any]?) {
        super.init(items: items)
        configureSegmentControl()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSegmentControl() {
        setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
        setTitleTextAttributes([.foregroundColor : UIColor.systemBlue], for: .normal)
        selectedSegmentTintColor = .systemBlue
        setWidth(80, forSegmentAt: 0)
        setWidth(80, forSegmentAt: 1)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemBlue.cgColor
        selectedSegmentIndex = 0
    }
}
