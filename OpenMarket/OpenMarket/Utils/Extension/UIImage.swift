//
//  UIImage.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/30.
//

import UIKit

extension UIImage {
    func getSize() -> Double {
        guard let data = self.jpegData(compressionQuality: 1) else {
            return .zero
        }
        
        let size = Double(data.count) / 1024
        return size
    }
    
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
}
