//
//  ImageData.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 1/12/2022.
//

import UIKit

struct ImageData {
    let fileName: String
    let data: Data
    
    init?(fileName:String, image: String) {
        guard let data = UIImage(named: image)?.jpegData(compressionQuality: 0.5) else { return nil }
        self.data = data
        self.fileName = fileName
    }
}
