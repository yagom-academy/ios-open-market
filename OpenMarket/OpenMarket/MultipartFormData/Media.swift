//
//  Media.swift
//  OpenMarket
//
//  Created by 임성민 on 2021/02/02.
//

import UIKit

struct Media {
    let key: String
    let fileName: String
    let mimeType: String
    let data: Data
    
    init?(key: String, fileName: String, mimeType: String, data: Data) {
        self.key = key
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
    }
}
