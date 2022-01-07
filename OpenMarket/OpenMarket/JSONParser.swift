//
//  JSONParser.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/04.
//

import Foundation

enum JSONParser<Element: Codable> {
  
  static func decode(data: Data) -> Result<Element, JSONParserError> {
    guard let decodedData = try? JSONDecoder().decode(Element.self, from: data) else {
      return .failure(.decodeFailed)
    }
    
    return .success(decodedData)
  }
  
  static func encode(data: Element) -> Result<Data, JSONParserError> {
    guard let encodedData = try? JSONEncoder().encode(data) else {
      return .failure(.encodeFailed)
    }
    
    return .success(encodedData)
  }
}
