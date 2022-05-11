//
//  MockTestData.swift
//  OpenMarketJSONTests
//
//  Created by 우롱차, Donnie on 2022/05/10.
//

import Foundation

final class MockTestData: NetworkAble {
    
    private enum FileInfo {
        static var fileName = "PageInformationTest"
        static var extensionType = "json"
    }
    
    func requestData(url: String,
                     completeHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let data = load(fileName: FileInfo.fileName,
                        extensionType: FileInfo.extensionType)
        
        guard let url = URLComponents(string: url)?.url else { return }
        let response = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                       httpVersion: "2",
                                       headerFields: nil)
        
        completeHandler(data, response, nil)
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
