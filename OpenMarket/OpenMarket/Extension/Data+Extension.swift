import UIKit.NSDataAsset

extension Data {
    mutating func append(_ string: String) throws {
        if let data = string.data(using: .utf8) {
            self.append(data)
        } else {
            throw AppendError.invalidOfValue
        }
    }
    
    mutating func append(_ data: Data?) throws {
        if let data = data {
            self.append(data)
        } else {
            throw AppendError.invalidOfValue
        }
    }
}
