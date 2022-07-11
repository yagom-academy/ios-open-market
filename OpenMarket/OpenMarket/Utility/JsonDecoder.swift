//
//  JsonDecoder.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/11.
//
import UIKit

func decodeJsonData() -> ProductPage? {
    guard let filePath = NSDataAsset.init(name: "MockData") else {
        return nil
    }
    
    let decoder = JSONDecoder()
    var fetchedData: ProductPage?
    do {
        fetchedData = try decoder.decode(ProductPage.self, from: filePath.data)
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
            break
        }
    }
    return fetchedData
}
