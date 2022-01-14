//
//  Decoder.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/07.
//

import UIKit

struct Decoder {
    let decoder = JSONDecoder()
    
    func parsePageJSON<T: Codable> (data: Data) -> T? {
        do {
            let pageJSON: Data = data
            let decodedPageJSON = try decoder.decode(T.self, from: pageJSON)
            return decodedPageJSON
        } catch {
            return nil
        }
    }
}
