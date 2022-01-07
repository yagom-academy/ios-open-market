//
//  ImageFile.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/04.
//

import Foundation

struct ImageFile {
    let name: String
    let data: Data
    let type: Form
    
    enum Form {
        case png
        case jpg
        case jpeg
        
        var description: String {
            switch self {
            case .png:
                return "image/png"
            case .jpg:
                return "image/jpg"
            case .jpeg:
                return "image/jpeg"
            }
        }
    }
}
