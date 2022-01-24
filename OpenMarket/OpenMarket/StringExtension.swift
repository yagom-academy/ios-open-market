//
//  StringExtension.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/21.
//

/**
 String타입의 숫자값에 천단위마다 comma를 insert한다.

 - Parameter doubleValue: String타입의 숫자값을 Double타입으로 변환한 값
 - Parameter insertedCommaDouble: doubleValue의 천단위에 comma를 삽입하고 String타입으로 변환한 값
 */

import Foundation

extension String {
    func insertCommaInThousands() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let doubleValue = Double(self),
              let insertedCommaDouble = numberFormatter.string(from: NSNumber(value: floor(doubleValue))) else {
         return  ""
        }
            return insertedCommaDouble
    }
    
}
