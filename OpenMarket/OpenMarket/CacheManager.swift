import Foundation

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
}
