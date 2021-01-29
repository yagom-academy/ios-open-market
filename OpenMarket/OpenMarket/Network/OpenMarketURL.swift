import Foundation

struct OpenMarketURL {
    static let openMarketFixedURL = "https://camp-open-market.herokuapp.com"
    static func makeURLPath(api: OpenMarketAPITypes, with pathParameter: UInt?) -> String {
        var pathString = api.urlPath
        if let parameter = pathParameter {
            pathString.append(String(parameter))
        }
        return pathString
    }
}
