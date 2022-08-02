//
//  DELETEProtocol.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/08/02.
//

import Foundation

protocol DELETEProtocol: APIProtocol { }

extension DELETEProtocol {
    func deleteProduct(using client: APIClient = APIClient.shared,
                       completion: @escaping (Result<Data,APIError>) -> Void) {
        var deleteRequest = URLRequest(url: configuration.url)
        deleteRequest.httpMethod = HTTPMethod.delete.rawValue
        deleteRequest.setValue(MIMEType.applicationJSON.value, forHTTPHeaderField: MIMEType.contentType.value)
        deleteRequest.addValue(User.identifier.rawValue, forHTTPHeaderField: RequestName.identifier.key)
        
        client.requestData(with: deleteRequest) { result in
            switch result {
            case .success(_):
                return
            case .failure(_):
                return
            }
        }
    }
}
