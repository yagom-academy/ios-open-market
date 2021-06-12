//
//  SegmentedControlViewController.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/09.
//

import UIKit

class SegmentedControl: UISegmentedControl {
    override init(items: [Any]? = ["LIST", "GRID"]){
        super.init(items: items)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.tintColor = UIColor.white
        self.backgroundColor = UIColor.lightGray
        self.selectedSegmentIndex = 0
        
        for index in 0...1 {
            self.setWidth(60, forSegmentAt: index)
        }
        
        self.sizeToFit()
        self.selectedSegmentIndex = 0
        self.sendActions(for: .valueChanged)
    }
}
