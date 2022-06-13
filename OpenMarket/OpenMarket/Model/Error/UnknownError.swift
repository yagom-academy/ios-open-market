//
//  UnknownError.swift
//  OpenMarket
//
//  Created by 우롱차 on 2022/06/09.
//

import Foundation

enum UnknownError: Error, LocalizedError, ErrorAlertProtocol {
    case unknown
    
    var alertTitle: String {
        return "알수없는 에러"
    }
    
    var alertMessage: String {
        return "개발자에게 문의하세요"
    }
}

