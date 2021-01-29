import Foundation

struct NetworkConfig {
    private static let openMarketFixedURL = "https://camp-open-market.herokuapp.com"
    
    static func makeURL(api: OpenMarketAPITypes, with pathParameter: UInt?) -> URL? {
        var urlComponents = URLComponents(string: openMarketFixedURL)
        var urlPathString = api.urlPath
        if let parameter = pathParameter {
            urlPathString.append(String(parameter))
        }
        urlComponents?.path = urlPathString
        return urlComponents?.url
    }
}
