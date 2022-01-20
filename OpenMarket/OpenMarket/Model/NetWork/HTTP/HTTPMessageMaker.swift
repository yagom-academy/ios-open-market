import Foundation

enum HTTPMessageMaker{
    
    struct Content {
        let headers: [String]
        let body: Data
    }
    
    static func createdMultipartBody(contents: [Content]) -> Data {
        let boundary = UUID().uuidString
        
        var body = Data()
        contents.forEach { (content) in
            body.append(string: "--\(boundary)\r\n")
            content.headers.forEach { (header) in
                body.append(string: "\(header)\r\n")
            }
            body.append(string: "\r\n")
            
            body.append(content.body)
            body.append(string: "\r\n")
        }
        body.append(string: "--\(boundary)--\r\n")
        
        return body
    }
}
