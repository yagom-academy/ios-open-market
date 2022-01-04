import Foundation
// 2-5 상품 list조회 , 
struct ProductPageHTTPResponse {
    let page_no: Int
    let items_per_page: Int
    let total_count: Int
    let offset: Int
    let limit: Int
    let last_page: Int
    let has_next: Bool
    let has_prev: Bool
    let pages: [ProductHTTPResponse]
    
    
}
