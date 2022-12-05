//
//  UIImage+.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/12/05.
//

import UIKit

extension UIImage {
    @discardableResult
    public func resize(_ scale: Double) -> UIImage? {
        let target = CGRect(x: 0, y: 0, width: (self.size.width * scale), height: (self.size.height * scale))
        guard let cgImage = self.cgImage,
              let context = CGContext(data: nil, width: Int(target.size.width), height: Int(target.size.height),
                                      bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: cgImage.bytesPerRow,
                                      space: cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: cgImage.bitmapInfo.rawValue)
        else {
            return self
        }
        context.interpolationQuality = .high
        context.draw(cgImage, in: target)
        
        let newImage = context.makeImage().flatMap { UIImage(cgImage: $0) }
        return newImage
    }
}
