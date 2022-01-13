import UIKit

struct ImageLoader {
    static func loadImage(from urlString: String?) -> UIImage? {
        guard let urlString = urlString,
              let imgURL = URL(string: urlString),
              let imgData = try? Data(contentsOf: imgURL) else {
            return nil
        }
        
        let image = UIImage(data: imgData)
        
        return image
    }
}
