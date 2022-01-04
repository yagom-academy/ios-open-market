import UIKit

enum Parser {
    static func decode(from jsonName: String) throws -> ProductList? {
        guard let data = NSDataAsset(name: jsonName) else {
            return nil
        }
        
        let products = try JSONDecoder().decode(ProductList.self, from: data.data)
        
        return products
    }
}
