//
//  UIImage+Extension.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/12/05.
//

import UIKit

extension UIImage {
    func resize() -> UIImage {
        let width = self.size.width
        let height = self.size.height
        let resizeLength: CGFloat = 150
        var scale: CGFloat
        
        if height >= width {
            scale = width <= resizeLength ? 1 : resizeLength / width
        } else {
            scale = height <= resizeLength ? 1 :resizeLength / height
        }
        
        let newHeight = height * scale
        let newWidth = width * scale
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
}
