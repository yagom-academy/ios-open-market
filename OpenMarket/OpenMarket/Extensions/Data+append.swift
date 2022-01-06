import Foundation

extension Data {
    mutating func appendString(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            return
        }
        self.append(data)
    }
}
