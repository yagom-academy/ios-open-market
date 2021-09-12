//
//  MultiPartForm.swift
//  OpenMarket
//
//  Created by 이예원 on 2021/09/06.
//

//import Foundation
//
//enum HTTPMethods: CustomStringConvertible {
//    case boundary
//    case httpHeader
//    case httpHeaderField
//    case contentDisposition
//    case lastBoundary
//    
//    var description: String {
//        switch self {
//        case .boundary:
//            return "Boundary-\(UUID().uuidString)"
//        case .httpHeader:
//            return "multipart/form-data; boundary=\(Self.boundary.description)"
//        case .httpHeaderField:
//            return "Content-Type:"
//        case .contentDisposition:
//            return "Content-Disposition: form-data; name="
//        case .lastBoundary:
//            return "--\(Self.boundary.description)--\r\n"
//        }
//    }
//}
