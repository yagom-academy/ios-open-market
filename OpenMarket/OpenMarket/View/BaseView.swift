//
//  BaseView.swift
//  OpenMarket
//
//  Created by papri, Tiana on 17/05/2022.
//

import UIKit

class BaseView: UIView {
    var segmentedControl: UISegmentedControl = {
        let titleFont = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        let selectedForegroundColor = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let normalForegroundColor = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        let segmentedControl = UISegmentedControl(items: ["LIST","GRID"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.setTitleTextAttributes(titleFont, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedForegroundColor, for: .selected)
        segmentedControl.setTitleTextAttributes(normalForegroundColor, for: .normal)
        segmentedControl.layer.borderWidth = 1.0
        segmentedControl.layer.cornerRadius = 5.0
        segmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        segmentedControl.layer.masksToBounds = true
        return segmentedControl
    }()
    
    init() {
        super.init(frame: .zero)
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            self.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func attribute() {
        backgroundColor = .systemBackground
    }
}
