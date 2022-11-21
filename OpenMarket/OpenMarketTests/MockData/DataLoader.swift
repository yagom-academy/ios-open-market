//
//  DataLoader.swift
//  OpenMarketTests
//
//  Created by Wonbi on 2022/11/15.
//

import Foundation

final class DataLoader {
    static func data(fileName: String) -> Data? {
        let fileURL = fileURL(of: fileName)
        let data = fileData(of: fileURL)
        
        return data
    }
    
    private static func fileURL(of fileName: String) -> URL? {
        let testBundle = Bundle(for: self)
        let filePath = testBundle.path(forResource: fileName, ofType: "json")
        
        if let filePath = filePath {
            return URL(fileURLWithPath: filePath)
        }
        return nil
    }
    
    private static func fileData(of fileURL: URL?) -> Data? {
        guard let fileURL = fileURL,
              let data = try? Data(contentsOf: fileURL) else { return nil }
        return data
    }
}
