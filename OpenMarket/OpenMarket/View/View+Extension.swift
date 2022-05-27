//
//  view+extension.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/18.
//

import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIStackView {
    func addLastBehind(view: UIView){
        let lastViewCount = self.accessibilityElementCount()
        if lastViewCount == 0 {
            self.insertArrangedSubview(view, at: 0)
        } else {
            self.insertArrangedSubview(view, at: 0)
        }
    }
}

extension UIImage {
    public func resized(to targetSize: CGSize) -> UIImage? {

        let target = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        guard let cgImage = self.cgImage,
              let context = CGContext(data: nil,
                                      width: Int(targetSize.width),
                                      height: Int(targetSize.height),
                                      bitsPerComponent: cgImage.bitsPerComponent,
                                      bytesPerRow: cgImage.bytesPerRow,
                                      space: cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: cgImage.bitmapInfo.rawValue) else { return self }
         context.interpolationQuality = .high
         context.draw(cgImage, in: target)

         let newImage = context.makeImage().flatMap { UIImage(cgImage: $0) }
         return newImage ?? self
     }
}
