//
//  Data+Extension.swift
//  OpenMarket
//
//  Created by  Red, Mino on 2022/05/11.
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
}
