//
//  UIImage.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/12/02.
//

import UIKit.UIImage

extension UIImage {
    func resized(newWidth: CGFloat) -> UIImage? {
        let scale: CGFloat = newWidth / size.width // 새 이미지 확대/축소 비율
        let newHeight: CGFloat = size.height * scale
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        self.draw(in: CGRectMake(0, 0, newWidth, newHeight))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
