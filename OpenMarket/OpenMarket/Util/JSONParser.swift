import Foundation

struct JSONParser: JSONParsable {
    let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy
    let keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy
    let keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy
    
    func decode<Element: Decodable>(from data: Data) throws -> Element {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
        let data = try decoder.decode(Element.self, from: data)
        return data
    }
    
    func encode<Element: Encodable>(from element: Element) throws -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = keyEncodingStrategy
        let data = try encoder.encode(element)
        return data
    }
    
    init(
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys
    ) {
        self.dateDecodingStrategy = dateDecodingStrategy
        self.keyDecodingStrategy = keyDecodingStrategy
        self.keyEncodingStrategy = keyEncodingStrategy
    }
}
