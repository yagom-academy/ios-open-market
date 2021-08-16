//
//  ParsingManager.swift
//  OpenMarket
//
//  Created by Kim Do hyung on 2021/08/13.
//

import Foundation

struct ParsingManager {
    let boundary = "Boundary-\(UUID().uuidString)"
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    func decodingData<T:Decodable>(data: Data, model: T.Type) -> T? {
        let convertedModel = try? decoder.decode(T.self, from: data)
        return convertedModel
    }
    
    func encodingModel<T:Encodable>(model: T) -> Data? {
        let convertedData = try? encoder.encode(model)
        return convertedData
    }
}

//post patch delete

extension ParsingManager {
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func createDataBody<T: APIModelProtocol>(model: T) -> Data? {
        var body = Data()
        let lineBreak = "\r\n"
        
        if let model = model as? MultiPartFormProtocol {
            for (key, value) in model.textField {
                body.append(convertTextField(key: key, value: value ?? ""))
            }
            guard let modelImages = model.images else { return nil }
            for image in modelImages {
                body.append(convertFileField(key: "images[]", source: "image", mimeType: "image/jpeg", value: image))
            }
            body.append("--\(generateBoundaryString())--\(lineBreak)")
        } else {
            if let data = encodingModel(model: model) {
                body = data
            }
        }
        return body
    }
    
    private func convertFileField(key: String, source: String, mimeType: String, value: Data) -> Data {
        let lineBreak = "\r\n"
        var dataField = Data()
        
        
        dataField.append("--\(boundary + lineBreak)")
        dataField.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(source)\"\(lineBreak)")
        dataField.append("Content-Type: \(mimeType + lineBreak + lineBreak)")
        dataField.append(value)
        dataField.append(lineBreak)
//        dataField.append("--\(generateBoundaryString())\(lineBreak)")
//        dataField.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(source)\"\(lineBreak)")
//        dataField.append("Content-Type: \"\(mimeType)\"\(lineBreak)\(lineBreak)")
//        dataField.append(value)
//        dataField.append("\(lineBreak)")
        
        return dataField
    }
    
    private func convertTextField(key: String, value: String) -> Data {
        let lineBreak = "\r\n"
        var textField = Data()
        
        
        textField.append("--\(boundary + lineBreak)")
        textField.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
        textField.append("\(value)\(lineBreak)")
//        textField.append("--\(generateBoundaryString())\(lineBreak)")
//        textField.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak)")
//        textField.append("\(lineBreak)")
//        textField.append("\(value)\(lineBreak)")
        
        return textField
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
