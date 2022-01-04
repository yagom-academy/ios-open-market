import XCTest

class OpenMarketTests: XCTestCase {
    
    func convertToNSDataAsset(from fileName: String) -> Data?  {
        guard let jsonData = NSDataAsset(name: fileName) else {
            return nil
        }
        return jsonData.data
    }
        
    func test_디코딩된_JSON데이터의_itemsPerPage가_20이어야_한다() {
        let data = convertToNSDataAsset(from: "products")!
        let decodedData = try! JSONParser.decodeData(of: data, how: OpenMarket.self)
        let result = decodedData.itemsPerPage
        
        XCTAssertEqual(result, 20)
    }
    
    func test_디코딩된_JSON데이터의_pages의_요소가_5개여야_한다() {
        let data = convertToNSDataAsset(from: "products")!
        let decodedData = try! JSONParser.decodeData(of: data, how: OpenMarket.self)
        let result = decodedData.pages.count
        
        XCTAssertEqual(result, 5)
    }
    
    func test_디코딩된_JSON데이터의_pages의_두번째요소가_팥빙수여야_한다() {
        let data = convertToNSDataAsset(from: "products")!
        let decodedData = try! JSONParser.decodeData(of: data, how: OpenMarket.self)
        let result = decodedData.pages[1].name
        
        XCTAssertEqual(result, "팥빙수")
    }
    
}
