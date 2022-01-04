import XCTest
@testable import OpenMarket

class JSONParseTests: XCTestCase {
    func test_상품_리스트_조회_decode가_되는지() {
        do {
            let decoded: ProductsList? = try JSONParser.decode(from: "products")
            XCTAssertEqual(decoded?.pages[0].currency, Currency.krw)
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    func test_상품_리스트_조회_날짜_decode가_되는지() {
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
    
    func test_상품_상세_조회_id_decode가_되는지() {
        do {
            let decoded: Product? = try JSONParser.decode(from: "product_16")
            XCTAssertEqual(decoded?.id, 16)
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    func test_상품_상세_조회_images_decode가_되는지() {
        do {
            let decoded: Product? = try JSONParser.decode(from: "product_16")
            XCTAssertEqual(decoded?.images?[0].id, 7)
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    func test_상품_상세_조회_vendor_decode가_되는지() {
        do {
            let decoded: Product? = try JSONParser.decode(from: "product_16")
            XCTAssertEqual(decoded?.vendor?.id, 2)
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
