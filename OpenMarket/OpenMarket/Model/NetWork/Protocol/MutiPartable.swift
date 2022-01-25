import Foundation
import UIKit

protocol MultiPartable { }

extension MultiPartable {
    func generateBoundary() -> String {
        return "\(UUID().uuidString)"
    }
    
    func createBody(productRegisterInformation: ProductPost.Request.Params, images: [UIImage], boundary: String) -> Data? {
        var body: Data = Data()
        
        guard let data = try? JSONEncoder().encode(productRegisterInformation) else {
            return nil
        }
        
        body.append(convertDataToMultiPartForm(value: data, boundary: boundary))
        
        images.forEach { image in
            guard let data = image.pngData() else {
                return
            }
            body.append(convertImageToMultiPartForm(fileName: "\(UUID().uuidString).png", fileData: data, using: boundary))
        }
        
        body.appendString("--\(boundary)--\r\n")
        return body
    }

    func convertDataToMultiPartForm(value: Data, boundary: String) -> Data {
        var data: Data = Data()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"params\"\r\n")
        data.appendString("Content-Type: application/json\r\n")
        data.appendString("\r\n")
        data.append(value)
        data.appendString("\r\n")

        return data
    }
    
    func convertImageToMultiPartForm(fileName: String, fileData: Data, using boundary: String) -> Data {
        var data: Data = Data()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: image/png\r\n")
        data.appendString("\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        
        return data
    }
}

    
