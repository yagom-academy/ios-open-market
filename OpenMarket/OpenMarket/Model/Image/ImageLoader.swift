import UIKit

enum ImageLoader {
    static func load(from urlString: String, completion: @escaping (Result<Data, NetworkingAPIError>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.requestDataTask(url: url, completion: completion)
    }
    
    static func load<T: URLSessionProtocol>(session: T,
                                            from urlString: String,
                                            completion: @escaping (Result<Data, NetworkingAPIError>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        session.requestDataTask(url: url, completion: completion)
    }
}
