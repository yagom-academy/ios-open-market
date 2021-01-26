
import Foundation

struct OpenMarketAPINetwork {
    let jsonDecoder = JSONDecoder()
    
    init() {
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
}
