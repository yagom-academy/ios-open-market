//
//  JsonDecoder.swift
//  OpenMarket
//
//  Created by 기원우 on 2021/05/12.
//

import Foundation
import UIKit

struct JsonDecoder {
    let jsonDecoder = JSONDecoder()
    
    func jsonDataLoad(dataName: String) -> Result<Data, OpenMarketError> {
        guard let jsonData: NSDataAsset = NSDataAsset(name: dataName) else {
            return .failure(OpenMarketError.notFindData)
        }
        
        return .success(jsonData.data)
    }
    
    func jsonDecode<T: Decodable>(data: Data, modelType: T) -> Result<T, OpenMarketError> {
        do {
            let result = try jsonDecoder.decode(T.self, from: data)
            return .success(result)
        } catch {
            return .failure(OpenMarketError.jsonParsingFail)
        }
    }
    
}
