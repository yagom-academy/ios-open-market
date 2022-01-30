//
//  UIImage+Extension.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/26.
//

import UIKit

extension UIImage {
    func compressed(to targetSize: CGSize) -> UIImage {
        let widthScaleRatio = targetSize.width / self.size.width
        let heightScaleRatio = targetSize.height / self.size.height
        
        let scaleRatio = min(widthScaleRatio, heightScaleRatio)
        
        let scaledImageSize = CGSize(width: self.size.width * scaleRatio, height: self.size.width * scaleRatio)
        
        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }
        
        return scaledImage
    }
    
    func cropAsSquare() -> UIImage {
        let convertedCGImage = self.cgImage!
        let width = convertedCGImage.width
        let height = convertedCGImage.height
        
        let newSizeValue = min(width, height)
        
        var centerRect = CGRect()
        
        centerRect = CGRect(x: (width - newSizeValue) / 2,
                            y: (height - newSizeValue) / 2,
                            width: newSizeValue,
                            height: newSizeValue)
        
        guard let croppedImage = convertedCGImage.cropping(to: centerRect) else {
            return UIImage()
        }
        
        return UIImage(cgImage: croppedImage)
    }
}
