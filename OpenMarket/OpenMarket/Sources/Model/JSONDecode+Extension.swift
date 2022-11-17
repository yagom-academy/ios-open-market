//
//  OpenMarket - JSONDecode+Extension.swift
//  Created by Zhilly, Dragon. 22/11/14
//  Copyright © yagom. All rights reserved.
//

import UIKit.NSDataAsset

extension JSONDecoder {
    static func decodeAsset<T: Decodable>(name: String, to type: T.Type) -> T? {
        let jsonDecoder: JSONDecoder = JSONDecoder()
        var decodedData: T?
        guard let dataAsset: NSDataAsset = NSDataAsset(name: name) else {
            return nil
        }
        
        do {
            decodedData = try jsonDecoder.decode(T.self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
        
        return decodedData
    }
    
    static func decodeData<T: Decodable>(data: Data, to type: T.Type) -> T? {
        let jsonDecoder: JSONDecoder = JSONDecoder()
        var decodedData: T?
        
        do {
            decodedData = try jsonDecoder.decode(T.self, from: data)
        } catch {
            print(error.localizedDescription)
        }
        
        return decodedData
    }
}
