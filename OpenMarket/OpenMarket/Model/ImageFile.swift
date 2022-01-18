//
//  ImageFile.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/18.
//

import Foundation

import Foundation

struct ImageFile {
  let name: String
  let data: Data
  let imageType: ImageType
  
  enum ImageType: String {
    case jpg
    case jpeg
    case png
    
    var type: String {
      switch self {
      case .jpg:
        return ".jpg"
      case .jpeg:
        return ".jpeg"
      case .png:
        return ".png"
      }
    }
    
    var mimeType: String {
      switch self {
      case .jpg:
        return "image/jpg"
      case .jpeg:
        return "image/jpeg"
      case .png:
        return "image/png"
      }
    }
  }
}
