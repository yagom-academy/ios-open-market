//
//  Double + Extension.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/27.
//

import Foundation

extension Double {
    var formatDouble: String {
        get throws {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            
            guard let string = formatter.string(for: self) else {
                throw DoubleError.formatterError
            }
            
            return string
        }
    }
    
    enum DoubleError: Error {
        case formatterError
    }
}

extension Int {
    var formatInt: String {
        get throws {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            
            guard let string = formatter.string(for: self) else {
                throw IntError.formatterError
            }
            
            return string
        }
    }
    
    enum IntError: Error {
        case formatterError
    }
}

