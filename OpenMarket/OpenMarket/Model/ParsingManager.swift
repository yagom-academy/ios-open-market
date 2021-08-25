//
//  ParsingManager.swift
//  OpenMarket
//
//  Created by Do Yi Lee on 2021/08/10.
//

import Foundation

enum ParsingError: LocalizedError {
    case decodingError
    case encodingError
    
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "디코딩에 실패하였습니다."
        case .encodingError:
            return "인코딩에 실패하였습니다."
        }
    }
}

enum ParsingManager {
    static func jsonDecode<T: Decodable>(data: Data, type:T.Type) throws -> T {
        do {
            let data = try JSONDecoder().decode(type, from: data)
            return data
        } catch {
            throw ParsingError.decodingError
        }
    }
    
    static func jsonEncode<T: Encodable>(data: T) throws -> Data {
        do {
            let jsonData = try JSONEncoder().encode(data)
            return jsonData
        } catch {
            throw ParsingError.encodingError
        }
    }
}
