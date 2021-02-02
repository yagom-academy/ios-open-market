//
//  Media.swift
//  OpenMarket
//
//  Created by 임성민 on 2021/02/02.
//

import UIKit

struct Media {
    let key: String
    let data: Data
    let fileName: String
    let mimeType: String
    
    init?(data: Data, mimeType: String, key: String, fileName: String) {
        self.key = key
        self.mimeType = mimeType
        self.fileName = fileName
        self.data = data
    }
}
