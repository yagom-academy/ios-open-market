//
//  LayoutSegmentedControl.swift
//  OpenMarket
//
//  Created by junho lee on 2022/11/22.
//

import UIKit

final class LayoutSegmentedControl: UISegmentedControl {
    init() {
        super.init(items: ["LIST", "GRID"])
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        setWidth(90, forSegmentAt: 0)
        setWidth(90, forSegmentAt: 1)
        selectedSegmentTintColor = .systemBlue
        backgroundColor = .systemBackground
        layer.borderColor = UIColor.systemBlue.cgColor
        layer.borderWidth = 1
        selectedSegmentIndex = 0
    }
}
