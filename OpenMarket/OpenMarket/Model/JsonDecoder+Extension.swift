//
//  JsonDecoder+Extension.swift
//  OpenMarket
//
//  Created by 서현웅 on 2022/11/15.
//

import Foundation
import UIKit

extension JSONDecoder {
    func decodeData<T: Decodable>(_ data: String) -> T? {
        guard let dataAsset: NSDataAsset = NSDataAsset(name: data) else {
            return nil
        }
        do {
            return try JSONDecoder().decode(T.self, from: dataAsset.data)
        } catch {
            print(error)
            print(error.localizedDescription)
            return nil
        }
    }

    func decodeData<T: Decodable>(_ data: Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}
