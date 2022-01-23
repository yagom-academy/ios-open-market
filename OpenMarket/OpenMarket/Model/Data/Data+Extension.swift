import Foundation

extension Data {
    mutating func append(string: String) {
        guard let data = string.data(using: .utf8) else {
            print(OpenMarketError.conversionFail("Data", "String").description)
            return
        }
        self.append(data)
    }
}
