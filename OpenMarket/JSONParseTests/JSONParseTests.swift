import XCTest
@testable import OpenMarket

class JSONParseTests: XCTestCase {
    func test_decode가_잘_되는지() {
        do {
            let decoded: ProductsList? = try JSONParser.decode(from: "products")
            XCTAssertEqual(decoded?.pageNumber, 1)
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
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let data = try decoder.decode(Element.self, from: asset.data)
        return data
    }
}
