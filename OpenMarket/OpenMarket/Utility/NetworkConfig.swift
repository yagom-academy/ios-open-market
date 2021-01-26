import Foundation

struct NetworkConfig {
    private static let openMarketFixedURL = "https://camp-open-market.herokuapp.com"
    
    static func makeURL(with api: OpenMarketAPITypes) -> URL? {
        var urlString = openMarketFixedURL
        urlString.append(api.urlQuery)
        return URL(string: urlString)
    }
}
