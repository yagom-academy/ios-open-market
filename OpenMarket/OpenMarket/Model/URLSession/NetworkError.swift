//
//  NetworkError.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 16/11/2022.
//

import Foundation

enum NetworkError: Error {
    case requestFailError
    case httpResponseError(code: Int)
    case noDataError
    case generateUrlFailError
    case parameterEncodingFailError
    case dataDecodingFailError
    case generateRequestFailError
    case generateImageDataFailError
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .requestFailError:
            return "Request Failed"
        case .httpResponseError(code: let code):
            return "Response is not included in 200-299, response: \(code)"
        case .noDataError:
            return "No Data"
        case .generateUrlFailError:
            return "Generate URL Failed"
        case .parameterEncodingFailError:
            return "Parameter Encoding Failed"
        case .dataDecodingFailError:
            return "data Decoding Failed"
        case .generateRequestFailError:
            return "generate Request Failed"
        case .generateImageDataFailError:
            return "generate Image Data Failed"
        }
    }
}
