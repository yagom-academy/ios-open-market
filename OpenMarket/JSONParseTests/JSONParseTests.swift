import XCTest
@testable import OpenMarket

class JSONParseTests: XCTestCase {
    func test_decode가_잘_되는지() {
        do {
            let decoded: ProductsList? = try JSONParser.decode(from: "products")
            XCTAssertEqual(decoded?.pages[0].currency, Currency.krw)
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    func test_날짜_decode가_잘_되는지() {
        do {
            let decoded: ProductsList? = try JSONParser.decode(from: "products")
            let date = decoded?.pages[0].issuedAt
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
            let test = formatter.string(from: date!)
            XCTAssertEqual(test, "2022-01-03T00:00:00.00")
        } catch {
            print(error)
            XCTFail()
        }
    }
}

enum JSONParser<Element: Decodable> {
    static func decode(from jsonFileName: String) throws -> Element? {
        guard let asset = NSDataAsset(name: jsonFileName) else {
            return nil
        }
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        decoder.dateDecodingStrategy = .formatted(formatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let data = try decoder.decode(Element.self, from: asset.data)
        return data
    }
}
