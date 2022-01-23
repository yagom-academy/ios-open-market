import Foundation

protocol MultiPartable { }
//헤더 -> 멀티파트폼데이터다 -> setvalue or addvalue
// identifier => 저희 id vender identification 

//바디 1
//바디 2
//이미지

extension MultiPartable {
    
    func generateBoundaryString() -> String {
          return "Boundary-\(UUID().uuidString)"
      }
    
    func convertFormField(named name: String, value: String, using boundary: String) -> Data {
        var data = Data()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        data.appendString("\r\n")
        data.appendString("\(value)\r\n")  // encoding된 타입

      return data as Data
    }
    
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        var data = Data()

      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n") // uuid 로 + 확장자
      data.appendString("Content-Type: \(mimeType)\r\n\r\n") // .jpg .png
      data.append(fileData) // 이미지 하나가 들어감
      data.appendString("\r\n")

      return data as Data
    }

    
}
