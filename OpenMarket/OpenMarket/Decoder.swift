//
//  Decoder.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/07.
//

import UIKit

let decoder = JSONDecoder()

func parsePageJSON() throws -> Page {
    guard let pageJSON: NSDataAsset = NSDataAsset(name: "products") else {
        throw NetworkError.parsingFailed
    }
    
    guard let decodedPageJSON = try decoder.decode(Page?.self, from: pageJSON.data) else {
        throw NetworkError.parsingFailed
    }
    
    return decodedPageJSON
}
