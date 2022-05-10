//
//  MockTestData.swift
//  OpenMarketJSONTests
//
//  Created by 우롱차, Donnie on 2022/05/10.
//

import Foundation

final class MockTestData: NetworkAble {
    func inquireProductList() -> Data? {
        let testFileName = "PageInformationTest"
        let extensionType = "json"
        
        let data = load(fileName: testFileName, extensionType: extensionType)
        return data
    }
    
    private func load(fileName: String, extensionType: String) -> Data? {
        let testBundle = Bundle(for: type(of: self))
        guard let fileLocation = testBundle.url(forResource: fileName, withExtension: extensionType) else { return nil }
        do {
            let data = try Data(contentsOf: fileLocation)
            return data
        } catch {
            return nil
        }
    }
}
