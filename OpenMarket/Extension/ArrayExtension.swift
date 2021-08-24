//
//  AboutFormData.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/23.
//

import UIKit

extension Array where Element == UIImage {
    func buildedFormData(boundary: String) -> Data {
        var imageDatas = [Data]()
        
        for image in self {
            guard let jpegData = image.jpegData(compressionQuality: 1) else {
                continue
            }
            
            imageDatas.append(jpegData)
        }
        
        var form = Data()
        
        for data in imageDatas {
            form += (boundary + .newLine).utf8
            form += "Content-Disposition: form-data; name=\"images[]\"".utf8
            form += (.newLine + "Content-Type: image/jpeg").utf8
            form += (.newLine + .newLine).utf8
            form += data + String.newLine.utf8
        }
        
        return form
    }
}

