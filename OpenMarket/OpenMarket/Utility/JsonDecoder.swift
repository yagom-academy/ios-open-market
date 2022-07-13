//
//  JsonDecoder.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/11.
//
import UIKit

func decode<T: Decodable>(from data: Data, to type: T.Type) -> T? {
    let decoder = JSONDecoder()
    var fetchedData: T
    do {
        fetchedData = try decoder.decode(type, from: data)
        return fetchedData
    } catch {
        switch error {
        case DecodingError.typeMismatch(let type, let context):
            let descriptionList = context.debugDescription.split(separator: " ")
            print("타입이 \(type) 가 아닙니다. \(descriptionList[descriptionList.count - 2]) 타입을 사용 해주세요.")
        case DecodingError.dataCorrupted(let context):
            print(context.debugDescription)
        case DecodingError.valueNotFound(_ , let context):
            print(context.debugDescription)
        case DecodingError.keyNotFound(_ , let context):
            print(context.debugDescription)
        default:
            print(error)
        }
        return nil
    }
}
