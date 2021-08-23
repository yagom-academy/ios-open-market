//
//  AboutFormData.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/23.
//

import Foundation

let newLine = "\r\n"

extension Loopable {
    func buildedFormData(boundary: String) -> Data {
        var form = ""
        
        for (key, value) in self.properties {
            form += boundary + newLine
            form += "Content-Disposition: form-data; "
            form += "name=\"\(key)\"" + newLine + newLine
            form += "\(String(describing: value))" + newLine
        }
        
        form += boundary +  "--"
        
        return form.data(using: .utf8) ?? Data()
    }
}

extension Array where Element == Data {
    func buildedFormData(boundary: String) -> Data {
        var form = Data()
        
        for data in self {
            form += (boundary + newLine).utf8
            form += "Content-Disposition: form-data; name=\"images[]\"".utf8
            form += (newLine + "Content-Type: image/jpeg").utf8
            form += (newLine + newLine).utf8
            form += data + newLine.utf8
        }
        
        return form
    }
}

