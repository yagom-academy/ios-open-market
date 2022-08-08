//
//  JsonDecoder.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/11.
//
import UIKit

func decode<T: Decodable>(from data: Data, to type: T.Type) -> T? {
    if type == String.self {
        return String(data: data, encoding: .utf8) as? T
    }
    let decoder = JSONDecoder()
    var fetchedData: T
    do {
        fetchedData = try decoder.decode(type, from: data)
        return fetchedData
    } catch {
        switch error {
        case DecodingError.typeMismatch(let type, let context):
            fatalError("\(type.self) ERROR - \(context.debugDescription)")
        case DecodingError.dataCorrupted(let context):
            fatalError(context.debugDescription)
        case DecodingError.valueNotFound(_ , let context):
            fatalError(context.debugDescription)
        case DecodingError.keyNotFound(_ , let context):
            fatalError(context.debugDescription)
        default:
            fatalError(error.localizedDescription)
        }
        return nil
    }
}
