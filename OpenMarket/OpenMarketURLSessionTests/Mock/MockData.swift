//
//  MockData.swift
//  OpenMarket
//
//  Created by Kiwi, Hugh on 2022/07/13.
//
import Foundation

struct MockData {
    let data: Data?
    
    init(fileName: String) {
        let location = Bundle.main.url(forResource: fileName, withExtension: "json")
        data = try? Data(contentsOf: location!)
    }
}
