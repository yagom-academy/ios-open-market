import XCTest

class ProductsTests: XCTestCase {
    var sut: Data?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = NSDataAsset(name: "products")?.data
    }
    
    func test_decoding된_JSON데이터의_productList의_pageNumber가_1인지() {
        let decodeResult = Parser<ProductList>.decode(from: sut!)
        let result = decodeResult!.pageNumber

        XCTAssertEqual(result, 1)
    }

    func test_decoding된_productList_pages의_첫번째데이터이름이_pizza인지() {
        let decodeResult = Parser<ProductList>.decode(from: sut!)
        let result = decodeResult!.pages[0].name

        XCTAssertEqual(result, "pizza")
    }
}
