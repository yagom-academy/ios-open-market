//
//  JSONParsingError.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/01/05.
//

import Foundation

enum JSONError: Error {
    case parsingError
}

extension JSONError {
    var description: String {
        switch self {
        case .parsingError:
            return "JSON 파싱을 실패했습니다."
        }
    }
}
