import Foundation

enum JSONParser {
    
    static func decodeData<T: Decodable>(of JSON: Data, type: T.Type) -> T? {
        let decoder = JSONDecoder()
        
        var decodedData: T?
        do {
            decoder.dataDecodingStrategy = .custom(imageDataDecoder)
            decodedData = try decoder.decode(type, from: JSON)
        } catch DecodingError.keyNotFound(let key, let context) {
            Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
        } catch let error as NSError {
            NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
        }
        
        return decodedData
    }
    
    static func imageDataDecoder(decoder: Decoder) throws -> Data {
        let container = try decoder.singleValueContainer()
        let str = try container.decode(URL.self)
        let imageData = try Data(contentsOf: str)
        
        return imageData
    }
    
    static func encodeToDataString<T: Encodable>(with modelData: T) -> String? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        var dataString: String?
        do {
            let encodedData = try encoder.encode(modelData)
            dataString = String(data: encodedData, encoding: .utf8)
        } catch let error as NSError {
            NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
        }

        return dataString
    }
    
    static func encodeToData<T: Encodable>(with modelData: T) -> Data? {
        let encoder = JSONEncoder()
        
        var data: Data?
        do {
            data = try encoder.encode(modelData)
        } catch let error as NSError {
            NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
        }
        
        return data
    }

}
