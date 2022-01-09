import Foundation

protocol JSONParsable { }

extension JSONParsable {
    func decode<T: Decodable>(data: Data, expecting: T.Type) -> T? {
        return try? JSONDecoder().decode(expecting, from: data)
    }
}
