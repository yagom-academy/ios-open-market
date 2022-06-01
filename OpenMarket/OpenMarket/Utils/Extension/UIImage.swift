//
//  UIImage.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/30.
//

import UIKit

fileprivate enum Attribute {
    enum Quality {
        static let highest: CGFloat = 1
    }
    
    enum Size {
        static let kilobyte: Double = 1024
    }
}

extension UIImage {
    
    func getSize() -> Double {
        guard let data = self.jpegData(compressionQuality: Attribute.Quality.highest) else {
            return .zero
        }
        
        let size = Double(data.count) / Attribute.Size.kilobyte
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
