//
//  CustomSegment.swift
//  OpenMarket
//
//  Created by song on 2022/05/19.
//

import UIKit

final class SegmentControl: UISegmentedControl {
    override init(items: [Any]?) {
        super.init(items: items)
        setupSegment()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSegment() {
        selectedSegmentTintColor = .systemBlue
        let nomalFontColor = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        setTitleTextAttributes(nomalFontColor, for: .normal)
        let selectedFontColor = [NSAttributedString.Key.foregroundColor: UIColor.white]
        setTitleTextAttributes(selectedFontColor, for: UIControl.State.selected)

        layer.addBorder(edges: [.all], color: .systemBlue, thickness: 2)
        selectedSegmentIndex = 0
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width / 2.0).isActive = true
    }
}
