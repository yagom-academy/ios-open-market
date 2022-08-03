import UIKit.NSDataAsset

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
    
    mutating func append(_ data: Data?) {
        if let data = data {
            self.append(data)
        }
    }
}
