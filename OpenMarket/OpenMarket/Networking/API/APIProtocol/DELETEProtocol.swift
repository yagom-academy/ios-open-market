//
//  DELETEProtocol.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

protocol DELETEProtocol: APIProtocol { }

extension DELETEProtocol {
    func deleteProduct(using client: APIClient = APIClient.shared) {
        var deleteRequest = URLRequest(url: configuration.url)
        deleteRequest.httpMethod = HTTPMethod.delete.rawValue
        deleteRequest.setValue(MIMEType.applicationJSON.value,
                               forHTTPHeaderField: MIMEType.contentType.value)
        deleteRequest.addValue(User.identifier.rawValue,
                               forHTTPHeaderField: RequestName.identifier.key)
        
        client.requestData(with: deleteRequest) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                break
            }
        }
    }
}
