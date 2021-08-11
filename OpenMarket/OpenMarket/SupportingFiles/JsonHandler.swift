//
//  JsonHandler.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/11.
//

import Foundation

enum DecodeError: Error {
    case decodeFail
    case notFoundFile
}

struct JsonHandler {
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func decodeJsonData<T: Decodable>(fileName: String, model: T.Type) throws -> T {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = readLocalFile(forName: fileName) else { throw DecodeError.notFoundFile }
        do {
            let result = try jsonDecoder.decode(model, from: data)
            return result
        } catch  {
            throw DecodeError.decodeFail
        }
    }
}
