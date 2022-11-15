//  Created by Aejong, Tottale on 2022/11/15.

import XCTest
@testable import OpenMarket

class DecodingTests: XCTestCase {
    
    func test_디코딩했을때_products가잘출력되는지() {
        guard let product: ProductPage = try? DecodeManger.shared.fetchData(name: "products") else { return }
        
        XCTAssertNotNil(product)
    }
}
