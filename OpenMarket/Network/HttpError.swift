//
//  httpError.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/16.
//

import Foundation

struct HttpError: ErrorMessage {
    
    enum Case: LocalizedError {
        case unknownError
        case requestBuildingFailed
        
        var errorDescription: String {
            switch self {
            case .requestBuildingFailed:
                return "Error: building request is failed"
            default:
                return "Error: unknown error occured"
            }
        }
        
    }
    
    
    var errorDescription: String?
    
    init(message: String) {
        self.errorDescription = message
    }
}
