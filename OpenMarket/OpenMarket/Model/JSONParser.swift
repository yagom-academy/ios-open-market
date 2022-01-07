import Foundation

enum JSONParser {
    
    static func decodeData<T: Decodable>(of JSON: Data, type: T.Type) -> T? {
        let decoder = JSONDecoder()
        var decodedData: T?
        do {
            decodedData = try decoder.decode(type, from: JSON)
        } catch {
            print(error.localizedDescription)
        }
        
        return decodedData
    }
    
}
