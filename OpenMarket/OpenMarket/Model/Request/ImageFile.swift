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
    
    enum Form: String {
        case png = ".png"
        case jpg = ".jpg"
        case jpeg = ".jpeg"
        
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
