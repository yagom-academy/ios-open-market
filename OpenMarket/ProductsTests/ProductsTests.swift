

import XCTest

class ProductsTests: XCTestCase {
    func test_없는_Json파일명을Parser에넣었을_때nil을반환하는지() {
        let notExistJsonName = "OpenMarket"
        let result = try! Parser.decode(from: notExistJsonName)
        
        XCTAssertNil(result)
    }
    
    func test_제대로된_JSON파일명을_Parser에_넣었을때_pageNumber가_1이_나오는지() {
        let jsonName = "products"
        let decoder = try! Parser.decode(from: jsonName)
        let result = decoder!.pageNumber
        
        XCTAssertEqual(result, 1)
    }
    
    func test_decoding된_JSON데이터의_pages의_첫번째_데이터의_이름이_pizza인지() {
        let jsonName = "products"
        let decoder = try! Parser.decode(from: jsonName)
        let result = decoder!.pages[0].name
        
        XCTAssertEqual(result, "pizza")
    }
}
