import XCTest
@testable import OpenMarket

class JSONParseTests: XCTestCase {
    let jsonParser: JSONParser = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        let jsonParser = JSONParser(
            dateDecodingStrategy: .formatted(formatter),
            keyDecodingStrategy: .convertFromSnakeCase,
            keyEncodingStrategy: .convertToSnakeCase
        )
        return jsonParser
    }()
    
    func test_상품_리스트_조회_decode가_되는지() {
        guard let asset = NSDataAsset(name: "products")?.data else {
            XCTFail()
            return
        }
        do {
            let decoded: ProductsList? = try jsonParser.decode(from: asset)
            XCTAssertEqual(decoded?.pages[0].currency, Currency.krw)
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    func test_상품_리스트_조회_날짜_decode가_되는지() {
        guard let asset = NSDataAsset(name: "products")?.data else {
            XCTFail()
            return
        }
        do {
            let decoded: ProductsList? = try jsonParser.decode(from: asset)
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
        guard let asset = NSDataAsset(name: "product_16")?.data else {
            XCTFail()
            return
        }
        do {
            let decoded: Product? = try jsonParser.decode(from: asset)
            XCTAssertEqual(decoded?.id, 16)
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    func test_상품_상세_조회_images_decode가_되는지() {
        guard let asset = NSDataAsset(name: "product_16")?.data else {
            XCTFail()
            return
        }
        do {
            let decoded: Product? = try jsonParser.decode(from: asset)
            XCTAssertEqual(decoded?.images?[0].id, 7)
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    func test_상품_상세_조회_vendor_decode가_되는지() {
        guard let asset = NSDataAsset(name: "product_16")?.data else {
            XCTFail()
            return
        }
        do {
            let decoded: Product? = try jsonParser.decode(from: asset)
            XCTAssertEqual(decoded?.vendor?.id, 2)
        } catch {
            print(error)
            XCTFail()
        }
    }
}
