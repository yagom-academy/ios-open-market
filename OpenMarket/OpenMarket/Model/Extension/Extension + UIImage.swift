//
//  Extension + UIImage.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/25.
//

import UIKit

extension UIImage {
    func resizeImage(kb: Int) -> UIImage? {
        var size = 500
        var image: UIImage? = self
        guard var imageData = image?.jpegData(compressionQuality: 1) else { return nil }
        while imageData.count/1000 > kb {
            UIGraphicsBeginImageContext(CGSize(width: size, height: size))
            image?.draw(in: CGRect(x: 0, y: 0, width: size, height: size))
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            guard let resizedImageData = image?.jpegData(compressionQuality: 1) else { return nil}
            imageData = resizedImageData
            size -= 1
        }
        return image
    }
}
