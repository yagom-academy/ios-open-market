//
//  JSONParser.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/04.
//

import Foundation

class JSONParser {
  static let shared = JSONParser()
  let decoder = JSONDecoder()
  let encoder = JSONEncoder()
  
  private init() { }
  
  func decode<Element: Codable>(
    data: Data,
    type: Element.Type
  ) -> Result<Element, JSONParserError> {
    guard let decodedData = try? decoder.decode(Element.self, from: data) else {
      return .failure(.decodeFailed)
    }
    
    return .success(decodedData)
  }
  
  func encode<Element: Codable>(
    data: Element,
    type: Element.Type
  ) -> Result<Data, JSONParserError> {
    guard let encodedData = try? encoder.encode(data) else {
      return .failure(.encodeFailed)
    }
    
    return .success(encodedData)
  }
}
