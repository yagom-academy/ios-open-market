//
//  UIImage + extension.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/08/01.
//

import UIKit

extension UIImage {
    
    func compress() -> Data? {
        let quality: CGFloat = 300 / self.sizeAsKilobyte()
        let compressedData: Data? = self.jpegData(compressionQuality: quality)
        return compressedData
    }
    
    private func sizeAsKilobyte() -> Double {
        guard let dataSize = self.pngData()?.count else { return 0 }
        
        return Double(dataSize / 1024)
    }
}
