//
//  UIImage+Extension.swift
//  OpenMarket
//
//  Created by 이정민 on 2022/12/05.
//

import UIKit

extension UIImage {
    public enum DataUnits: String {
        case byte, kilobyte, megabyte, gigabyte
    }
    
    func resizeImageTo(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    func getSizeIn(_ type: DataUnits)-> Double {
        guard let data = self.pngData() else {
            return 0
        }

        var size: Double = 0.0

        switch type {
        case .byte:
            size = Double(data.count)
        case .kilobyte:
            size = Double(data.count) / 1024
        case .megabyte:
            size = Double(data.count) / 1024 / 1024
        case .gigabyte:
            size = Double(data.count) / 1024 / 1024 / 1024
        }
        print(size)
        return size
    }
}
