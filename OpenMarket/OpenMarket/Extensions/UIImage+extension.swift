//
//  UIImage+extension.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/25.
//

import UIKit

extension UIImage {
    func resize(ratio: CGFloat) -> UIImage {
        let width = self.size.width / ratio
        let height = self.size.height / ratio
        let size = CGSize(width: width, height: height)
        let render = UIGraphicsImageRenderer(size: size)
        let renderedImage = render.image { _ in
            draw(in: CGRect(origin:.zero, size: size))
        }
        return renderedImage
    }
    
    func resize(target: CGSize) -> UIImage {
        let widthRatio = target.width / self.size.width
        let heightRatio = target.height / self.size.height
        
        let ratio = min(widthRatio, heightRatio)
        let size = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        let render = UIGraphicsImageRenderer(size: size)
        let renderedImage = render.image { _ in
            draw(in: CGRect(origin:.zero, size: size))
        }
        return renderedImage
    }
    
    func size() -> CGFloat {
        guard let imageDataSize = self.jpegData(compressionQuality: 1.0)?.count else {
            return 0.0
        }
        let imageSize = Double(imageDataSize) / 1024
        return imageSize
    }
}
