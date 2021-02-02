//
//  OpenMarketError.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/01/29.
//

import Foundation

enum OpenMarketError: Error {
    case convertData
    case fillForm
}

extension OpenMarketError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .convertData:
            return "데이터를 변환하는데 문제가 있습니다.\n잠시 후 다시 시도해 주세요."
        case .fillForm:
            return "항목을 모두 채워주세요."
        }
    }
}
