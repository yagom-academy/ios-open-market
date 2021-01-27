
import Foundation

struct OpenMarketURLMaker {
    static func makeRequestURL(httpMethod: HTTPMethods, mode: FeatureList) -> URLRequest? {
        guard let validURL = URL(string: "\(OpenMarketAPIManager.baseURL)\(mode.urlPath)") else {
            print(OpenMarketNetworkError.invalidURL)
            return nil
        }
        
        var urlRequest = URLRequest(url: (validURL))
        urlRequest.httpMethod = httpMethod.rawValue
    
        return urlRequest
    }
}
