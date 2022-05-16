//
//  Encodable+Extension.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/05/16.
//

import Foundation

extension Encodable {
    func toDictionary() -> Result<[String: Any], NetworkError> {
        do {
            let data = try JSONEncoder().encode(self)
            guard let jsonData = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                return .failure(.decodeError)
            }
            return .success(jsonData)
        } catch {
            return .failure(.decodeError)
        }
    }
}
