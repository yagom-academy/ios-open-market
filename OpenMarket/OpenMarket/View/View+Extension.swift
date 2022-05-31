//
//  View+Extension.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/18.
//

import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIStackView {
    func addLastBehind(view: UIView) {
        let lastViewCount = self.arrangedSubviews.count
        let index = lastViewCount <= 1 ? 0 : lastViewCount - 1
                self.insertArrangedSubview(view, at: index)
    }
}

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }
}
