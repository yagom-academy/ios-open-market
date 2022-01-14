import UIKit

enum ImageLoader {
    static func load(from urlString: String) -> UIImage? {
        guard let url = URL(string: urlString),
            let data = try? Data(contentsOf: url) else {
                return nil
            }
        return UIImage(data: data)
    }
}
