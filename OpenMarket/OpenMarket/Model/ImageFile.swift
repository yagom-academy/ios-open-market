//
//  ImageFile.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/18.
//

import Foundation

/**
 이미지의 모델 타입 (Request)
*/
struct ImageFile {
  let name: String
  let data: Data
  let imageType: contentsType
  
  enum contentsType: String {
    case jpg = ".jpg"
    case jpeg = ".jpeg"
    case png = ".png"
    
    var mime: String {
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
