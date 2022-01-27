//
//  JSONParser.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/04.
//

import Foundation

struct JSONParser {
  private let decoder = JSONDecoder()
  private let encoder = JSONEncoder()
  
  func decode<Element: Decodable>(
    data: Data
  ) -> Result<Element, NetworkError> {
    guard let decodedData: Element = try? decoder.decode(Element.self, from: data) else {
      return .failure(.decodeFailed)
    }
    
    return .success(decodedData)
  }
  
  func encode<Element: Encodable>(
    data: Element
  ) -> Result<Data, NetworkError> {
    guard let encodedData = try? encoder.encode(data) else {
      return .failure(.encodeFailed)
    }
    
    return .success(encodedData)
  }
}
