//
//  JSONParser.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/04.
//

import Foundation

enum JSONParser<Element: Codable> {
  
  static func decode(data: Data) -> Element? {
    let decodedData = try? JSONDecoder().decode(Element.self, from: data)
    
    return decodedData
  }
  
  static func encode(data: Element) -> Data? {
    let encodedData = try? JSONEncoder().encode(data)
    
    return encodedData
  }
}
