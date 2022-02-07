import UIKit

enum ImageLoader {
    static let cachedImages = NSCache<NSURL, NSData>()
    
    static func load<T: URLSessionProtocol>(
        session: T,
        from urlString: String,
        completion: @escaping (Result<Data, OpenMarketError>) -> ()
    ) {
        if let url = NSURL(string: urlString),
           let cachedImageData = cachedImages.object(forKey: url) {
            DispatchQueue.main.async {
                let data = Data(referencing: cachedImageData)
                completion(.success(data))
            }
            return
        }

        guard let url = URL(string: urlString) else {
            print(OpenMarketError.conversionFail("string", "URL").description)
            return
        }
        
        session.requestImageDataTask(url: url, completion: completion)
    }
}
