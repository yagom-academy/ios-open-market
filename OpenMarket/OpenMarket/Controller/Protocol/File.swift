//
//  File.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/20.
//

import UIKit

protocol CornerCurvable: UIView { }
extension CornerCurvable {
    func makeBeautiful() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
}
class CornerCurvedTextField: UITextField, CornerCurvable {
    var insetX: CGFloat = 10
    var insetY: CGFloat = 6

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
}
class CornerCurvedSegmentedControl: UISegmentedControl, CornerCurvable { }
