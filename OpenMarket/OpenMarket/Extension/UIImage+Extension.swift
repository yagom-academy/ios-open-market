//
//  UIImage+Extension.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/26.
//

import Foundation
import UIKit

extension UIImage {
    func compressedImage(targetSize: CGSize) -> UIImage {
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
}
