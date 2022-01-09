//
//  Extension+JSONDecoder.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/09.
//

import Foundation

extension JSONDecoder {
    
    static let shared = JSONDecoder(format: "yyyy-MM-dd'T'HH:mm:ss.SS")
    
    convenience init(format: String) {
        self.init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        self.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
}
