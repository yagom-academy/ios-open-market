import UIKit

enum Parser<Element: Decodable> {
    static func decode(from data: Data) -> Element? {
        var products: Element?
        
        do {
            products = try JSONDecoder().decode(Element.self, from: data)
        } catch {
            print("error message : \(error.localizedDescription)")
        }

        return products
    }
}

