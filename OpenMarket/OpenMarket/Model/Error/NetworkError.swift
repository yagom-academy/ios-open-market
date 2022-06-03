//
//  NetworkError.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/13.
//

import Foundation

enum NetworkError: Error, LocalizedError, ErrorAlertProtocol {
    case urlError
    case sessionError
    case statusCodeError
    case dataError
    
    var alertTitle: String {
            return "네트워크 통신 에러!"
    }
    
    var alertMessage: String {
        switch self {
        case .urlError:
           return "url 에러입니다."
        case .sessionError:
            return "세션 에러입니다."
        case .statusCodeError:
            return "서버 통신 오류입니다."
        case .dataError:
            return "데이터 포멧 오류입니다."
        }
    }
}
