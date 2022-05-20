//
//  UICollectionViewCell+extension.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/17.
//

import UIKit

extension UICollectionViewCell {
    func createLabel(font: UIFont, textColor: UIColor, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        
        label.font = font
        label.textColor = textColor
        label.textAlignment = alignment
        
        return label
    }
    
    func createStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        
        return stackView
    }
    
    func createStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat, margin: UIEdgeInsets) -> UIStackView {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = margin
        
        return stackView
    }
    
    func createImageView(contentMode: ContentMode) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        return imageView
    }
}
