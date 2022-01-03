import Foundation

enum JSONParser {
    
    static func decodeData<T: Decodable>(of JSON: Data, how: T.Type) throws -> T {
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(how, from: JSON)
        return decodedData
    }
    
}

