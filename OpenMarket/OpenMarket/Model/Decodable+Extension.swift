//
//  Decodable+Extension.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

extension Decodable {
  static func decode(from fileName: String) -> Self? {
    guard let asset = NSDataAsset(name: fileName) else {
      return nil
    }
    let decodedData = try? JSONDecoder().decode(Self.self, from: asset.data)
    return decodedData
  }
}
