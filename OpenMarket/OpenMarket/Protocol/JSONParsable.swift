import Foundation

protocol JSONParsable {
    func decode<Element: Decodable>(from data: Data) throws -> Element
    func encode<Element: Encodable>(from element: Element) throws -> Data
}
