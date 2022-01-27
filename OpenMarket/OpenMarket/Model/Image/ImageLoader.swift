import UIKit

enum ImageLoader {
    static func load(from urlString: String, completion: @escaping (Result<Data, OpenMarketError>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            print(OpenMarketError.conversionFail("string", "URL").description)
            return
        }
        
        URLSession.shared.requestDataTask(url: url, completion: completion)
    }
    
    static func load<T: URLSessionProtocol>(session: T,
                                            from urlString: String,
                                            completion: @escaping (Result<Data, OpenMarketError>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            print(OpenMarketError.conversionFail("string", "URL").description)
            return
        }
        
        session.requestDataTask(url: url, completion: completion)
    }
}
