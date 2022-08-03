import UIKit.NSDataAsset

struct ImageInfo {
    static let key: String = "images"
    
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage) {
        self.mimeType = "image/jpeg"
        self.filename = "image\(arc4random()).jpeg"
        
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        self.data = data
    }
    
    func getReducedImageData(to kb: Int) -> Data? {
        var compressionQuality = 1.0
        let targetFileSize = kb * 1024
        let image = UIImage(data: self.data)
        guard var compressedData = image?.jpegData(compressionQuality: compressionQuality) else { return nil }
        
        while compressedData.count > targetFileSize && compressionQuality >= 0 {
            compressionQuality -= 0.05
            guard let newCompresserData = image?.jpegData(compressionQuality: compressionQuality) else { return nil }
            compressedData = newCompresserData
        }
        
        return compressedData
    }
}
