import UIKit

struct ImageLoader {
    private static let imageCache = NSCache<NSString, UIImage>()
    
    static func loadImage(from urlString: String?) -> UIImage? {
        guard let urlString = urlString,
              let imgURL = URL(string: urlString) else {
            return nil
        }
        
        if let image = imageCache.object(forKey: imgURL.lastPathComponent as NSString) {
            return image
        }
        
        guard let imageData = try? Data(contentsOf: imgURL),
              let image = UIImage(data: imageData) else {
            return nil
        }
        
        imageCache.setObject(image, forKey: imgURL.lastPathComponent as NSString)
        
        return image
    }
}
