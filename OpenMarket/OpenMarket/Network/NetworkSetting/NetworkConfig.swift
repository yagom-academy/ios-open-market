import Foundation

struct NetworkConfig {
    static let openMarketFixedURL = "https://camp-open-market.herokuapp.com"

    enum headerType {
        static let json = "application/json"
        static let multipartForm = "multipart/form-data; boundary=%@"
    }
    
    static func makeURLPath(api: OpenMarketAPITypes, with pathParameter: UInt?) -> String {
        var pathString = api.urlPath
        if let parameter = pathParameter {
            pathString.append(String(parameter))
        }
        return pathString
    }
}
