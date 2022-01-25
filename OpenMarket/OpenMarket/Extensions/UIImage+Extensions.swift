//
//  UIImage+Extensions.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/25.
//

import Foundation
import UIKit

extension UIImage {
    func resizeImage(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
