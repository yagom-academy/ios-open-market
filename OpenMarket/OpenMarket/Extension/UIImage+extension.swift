//
//  UIImage+extension.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/18.
//

import UIKit

extension UIImage {
    func resized(percentage: CGFloat) -> UIImage {
        let size = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func compress() -> UIImage {
        var compressImage = self
        var quality: CGFloat = 1
        let maxDataSize = 307200
        guard var compressedImageData = compressImage.jpegData(compressionQuality: 1) else {
            return UIImage()
        }
        while compressedImageData.count > maxDataSize {
            quality *= 0.8
            compressImage = compressImage.resized(percentage: quality)
            compressedImageData = compressImage.jpegData(compressionQuality: quality) ?? Data()
        }
        return compressImage
    }
}
