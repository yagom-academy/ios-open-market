//
//  UIImage+extension.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/18.
//

import UIKit

extension UIImage {
    private func resize(percentage: CGFloat) -> UIImage {
        let size = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func compress() -> UIImage {
        var compressedImage = self
        var quality: CGFloat = 1
        let maxDataSize = 307200
        guard var compressedImageData = compressedImage.jpegData(compressionQuality: 1) else {
            return UIImage()
        }
        while compressedImageData.count > maxDataSize {
            quality *= 0.8
            compressedImage = compressedImage.resize(percentage: quality)
            compressedImageData = compressedImage.jpegData(compressionQuality: quality) ?? Data()
        }
        return compressedImage
    }
}
