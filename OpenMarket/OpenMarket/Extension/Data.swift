//
//  Data+Extension.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/05/16.
//

import Foundation

extension Data {
    func decode<T: Decodable>() -> Result<T, Error> {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: self)
            return .success(decoded)
        } catch {
            return .failure(NetworkError.decodeError)
        }
    }
    
    mutating func appendString(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            return
        }
        self.append(data)
    }
}
