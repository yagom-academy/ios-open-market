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
    
    func compress(ratio: CGFloat) -> UIImage {
        guard let jpegData = self.jpegData(compressionQuality: 1 / ratio) else {
            return self
        }
        guard let compressedImage = UIImage(data: jpegData) else {
            return self
        }
        return compressedImage
    }
    
    func size() -> CGFloat {
        guard let imageDataSize = self.jpegData(compressionQuality: 1.0)?.count else {
            return 0.0
        }
        let imageSize = Double(imageDataSize) / 1024
        return imageSize
    }
}
