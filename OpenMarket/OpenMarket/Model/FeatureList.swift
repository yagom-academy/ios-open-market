
import Foundation

enum FeatureList {
    case listSearch(page: Int)
    case productRegistration
    case productSearch(id: Int)
    case productModification(id: Int)
    case deleteProduct(id: Int)
    
    var urlPath: String {
        switch self {
        case .listSearch(let page):
            return "/items/\(page)"
        case .productRegistration:
            return "/item"
        case .productSearch(let id):
            return "/item/\(id)"
        case .productModification(let id):
            return "/item/\(id)"
        case .deleteProduct(let id):
            return "/item/\(id)"
        }
    }
}

