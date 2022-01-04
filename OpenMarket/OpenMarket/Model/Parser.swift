import UIKit

enum Parser<Element: Decodable> {
    static func decode(from data: Data) throws -> Element? {
        let products = try JSONDecoder().decode(Element.self, from: data)
        
        return products
    }
}
