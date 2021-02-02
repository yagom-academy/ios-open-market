import Foundation

struct NetworkConfig {
    static let openMarketFixedURL = "https://camp-open-market.herokuapp.com"
    static let jsonContentType = ["Content-Type": "application/json"]
    static let multipartContentType = ["multipart/form-data": "aplication/json"]
    
    static func makeURLPath(api: OpenMarketAPITypes, with pathParameter: UInt?) -> String {
        var pathString = api.urlPath
        if let parameter = pathParameter {
            pathString.append(String(parameter))
        }
        return pathString
    }
}
