import Foundation
import UIKit

class CacheManager {
    static let imageCache = URLCache(memoryCapacity: 300 * 1024 * 1024,
                                     diskCapacity: 1000 * 1024 * 1024,
                                     directory: cacheDirectory)

    private static let cacheDirectory: URL? = {
        let url = try? FileManager.default.url(
            for: .cachesDirectory,
               in: .allDomainsMask,
               appropriateFor: nil,
               create: false)
        return url
    }()

    static func fetchImage(imageURL: URL, completionHandler: @escaping (UIImage) -> Void) {
        let request = URLRequest(url: imageURL)

        if self.imageCache.cachedResponse(for: request) == nil {
            self.downloadImage(request: request) { image in
                completionHandler(image)
            }
        } else {
            self.loadImageFromCache(request: request) { image in
                completionHandler(image)
            }
        }
    }

    static func downloadImage(
        request: URLRequest,
        completionHandler: @escaping (UIImage) -> Void
    ) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let data = data else {
                return
            }
            guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                return
            }
            let cachedResponse = CachedURLResponse(response: response, data: data)
            self.imageCache.storeCachedResponse(cachedResponse, for: request)
            guard let image = UIImage(data: data) else {
                return
            }
            completionHandler(image)

        }
        dataTask.resume()
    }

    static func loadImageFromCache(
        request: URLRequest,
        completionHandler: @escaping (UIImage) -> Void
    ) {
        if let data = self.imageCache.cachedResponse(for: request)?.data {
            guard let image = UIImage(data: data) else {
                return
            }
            completionHandler(image)
        }
    }
}
