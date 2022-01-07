import Foundation

struct ImageData {
    let fileName: String
    let data: Data
    let type: ImageType
    
    enum ImageType {
        case jpg
        case jpeg
        case png
        
        var description: String {
            switch self {
            case .jpg:
                return "jpg"
            case .jpeg:
                return "jpeg"
            case .png:
                return "png"
            }
        }
    }
}
