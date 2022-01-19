import Foundation

struct NewProductImage {
    let key: String
    let fileName: String
    let image: Data
    
    init(key: String = "images", fileName: String = "test.jpg", image: Data) {
        self.key = key
        self.fileName = fileName
        self.image = image
    }
}
