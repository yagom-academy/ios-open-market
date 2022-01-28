import UIKit

struct ImageLoader {
    private static let imageCache = NSCache<NSString, UIImage>()
    
    static func loadImage(from urlString: String?, completion: @escaping (UIImage) -> Void) {
        guard let urlString = urlString,
              let imgURL = URL(string: urlString) else {
            return
        }
                
        if let image = imageCache.object(forKey: imgURL.lastPathComponent as NSString) {
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        URLSession.shared.dataTask(with: imgURL) { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                return
            }
            
            guard let data = data else {
                return
            }

            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else {
                    return
                }
                imageCache.setObject(image, forKey: imgURL.lastPathComponent as NSString)
                completion(image)
            }
        }.resume()
    }
}
