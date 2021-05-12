//
//  JsonDecoder.swift
//  OpenMarket
//
//  Created by 기원우 on 2021/05/12.
//

import Foundation
import UIKit

struct JsonDecoder {
    static let jsonDecoder = JSONDecoder()
    
    static func jsonDataLoad(dataName: String) throws -> Data {
        guard let jsonData: NSDataAsset = NSDataAsset(name: dataName) else {
            throw OpenMarketError.notFindData
        }
        
        return jsonData.data
    }
    
    static func jsonDecode<T: Decodable>(data: Data, modelType: T.Type) -> Result<T, OpenMarketError> {
        do {
            let result = try jsonDecoder.decode(T.self, from: data)
            return .success(result)
        } catch {
            return .failure(OpenMarketError.jsonParsingFail)
        }
    }
    
}
