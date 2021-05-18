//
//  RequestBodyEncoder.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/18.
//

import Foundation

struct RequestBodyEncoder: RequestBodyEncoderProtocol {
    static let boundary: String = "Boundary-\(UUID().uuidString)"

    func encode<T: RequestData>(_ value: T) throws -> Data {
        if value is JSONData {
            do {
                let data = try JSONEncoder().encode(value)

                return data
            } catch {
                throw OpenMarketError.JSONEncodingError
            }
        }

        var formDataBody = Data()

        guard let formData = value as? FormData else {
            throw OpenMarketError.invalidData
        }

        for textField in formData.textFields {
            formDataBody.append(convertTextField(key: textField.key,
                                                 value: textField.value))
        }

        for fileField in formData.fileFields {
            formDataBody.append(convertFileField(key: fileField.key,
                                                 source: "image0.jpg",
                                                 mimeType: "image/jpeg",
                                                 value: fileField.value))
        }

        formDataBody.append("--\(Self.boundary)--")
        return formDataBody
    }

    private func convertFileField(key: String, source: String, mimeType: String, value: Data) -> Data {
        var dataField = Data()

        dataField.append("--\(Self.boundary)\r\n")
        dataField.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(source)\"\r\n")
        dataField.append("Content-Type: \"\(mimeType)\"\r\n\r\n")
        dataField.append(value)
        dataField.append("\r\n")

        return dataField
    }

    private func convertTextField(key: String, value: String) -> String {
        var textField: String = "--\(Self.boundary)\r\n"

        textField.append("Content-Disposition: form-data; name=\"\(key)\"\r\n")
        textField.append("\r\n")
        textField.append("\(value)\r\n")

        return textField
    }
}
