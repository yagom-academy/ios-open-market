import Foundation
// 2 상품등록, 2-1 상품수정 , 2-3 상품삭제 , 2-4 상품상세조회, 
struct ProductHTTPResponse {
    let id: Int
    let vendor_id: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Int
    let bargain_price: Int
    let discounted_price: Int
    let stock: Int
    let images: [Image]?
    let vendors: Vendor?
    let created_at: String
    let issued_at: String

    enum Currency: String, Codable {
        case KRW
        case USD
    }
    
    struct Image: Codable {
        let id: Int
        let url: String
        let thumbnail_url: String
        let succeed: Bool?
        let issued_at: String
    }
    
    struct Vendor: Codable {
        let name: String
        let id: Int
        let created_at: String
        let issued_at: String
    }
}
