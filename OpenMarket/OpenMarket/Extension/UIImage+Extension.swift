//
//  UIImage+Extension.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/08/03.
//

import UIKit

extension UIImage {
    func logImageSizeInKB(scale: CGFloat) -> Int {
        let data = self.jpegData(compressionQuality: scale)!
        let formatter = ByteCountFormatter()
        
        formatter.allowedUnits = ByteCountFormatter.Units.useKB
        formatter.countStyle = ByteCountFormatter.CountStyle.file
        
        return Int(Int64(data.count) / 1024)
    }
}
