//
//  UIImage.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

// MARK: - Image 압축 메서드
extension UIImage {
    func convertDownSamplingImage() -> UIImage {
        var originImage = self
        var imageScale = 1.0
        var imageSize = originImage.compressionSize
        
        if originImage.size.height != originImage.size.width {
            originImage = originImage.resizeOfSquare()
            imageSize = originImage.compressionSize
        }
        
        while imageSize ?? 0 > 60000 {
            originImage = originImage.downSampling(scale: imageScale)
            imageSize = originImage.compressionSize
            imageScale -= 0.1
        }
        
        return originImage
    }
}

private extension UIImage {
    var compressionSize: Int? {
        return self.jpegData(compressionQuality: 0.5)?.count
    }
    func resizeOfSquare() -> UIImage {
        let minLength = min(self.size.width, self.size.height)
        let size = CGSize(width: minLength, height: minLength)
        
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }

    func downSampling(scale: Double) -> UIImage {
        guard let data = self.jpegData(compressionQuality: 0.5),
              let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
            return self
        }
        
        let maxPixel = min(self.size.width, self.size.height) * scale
        let downSampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixel
        ] as CFDictionary
        
        guard let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions) else {
            return self
        }
        
        let newImage = UIImage(cgImage: downSampledImage)
        
        return newImage
    }
}

// MARK: - Image HttpBody 변환 메서드
extension UIImage: HttpBodyConvertible {
    var contentType: ContentType {
        return .image
    }
    
    var data: Data {
        guard let imageData = self.pngData() else {
            return Data()
        }
        
        return imageData
    }
}
