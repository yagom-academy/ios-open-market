import Foundation

struct NetworkConfig {
    private static let openMarketFixedURL = "https://camp-open-market.herokuapp.com"
    
    static func makeURL(with api: OpenMarketAPITypes) -> URL? {
        var urlComponents = URLComponents(string: openMarketFixedURL)
        urlComponents?.path = api.urlPath
        return urlComponents?.url
    }
}
