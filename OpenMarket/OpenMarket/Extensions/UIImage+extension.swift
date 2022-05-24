//
//  UIImage+extension.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/25.
//

import UIKit

extension UIImage {
    func resize(ratio: Double) -> UIImage {
        let width = self.size.width / ratio
        let height = self.size.height / ratio
        
        let size = CGSize(width: width, height: height)
        let render = UIGraphicsImageRenderer(size: size)
        let renderedImage = render.image { _ in
            draw(in: CGRect(origin:.zero, size: size))
        }
        return renderedImage
    }
}
