//
//  UIImage+.swift
//  OpenMarket
//
//  Created by marisol on 2022/05/28.
//

import UIKit

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: size)
        let renderedImage = renderer.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderedImage
    }
    
    func checkImageCapacity() -> Double {
        var capacity: Double = 0.0
        guard let data = self.pngData() else {
            return 0.0
        }
        
        capacity = Double(data.count) / 1024
        
        return capacity
    }
}
