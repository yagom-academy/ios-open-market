import Foundation

enum JSONParser {
    
    static func decodeData<T: Decodable>(of JSON: Data, how: T.Type) -> T? {
        let decoder = JSONDecoder()
        var decodedData: T?
        do {
            decodedData = try decoder.decode(how, from: JSON)
        } catch {
            print(error.localizedDescription)
        }
        
        return decodedData
    }
    
}
