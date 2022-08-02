//
//  PATCHProtocol.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

protocol PATCHProtocol: APIProtocol { }

extension PATCHProtocol {
    func modifyData(using client: APIClient = APIClient.shared,
                    modifiedProductEntity: ModifiedProductEntity,
                    completion: @escaping (Result<Data,APIError>) -> Void) {
        
        var request = URLRequest(url: configuration.url)
        
        request.httpBody = modifiedProductEntity.returnValue()
        request.httpMethod = HTTPMethod.patch.rawValue
        request.setValue(MIMEType.applicationJSON.value,
                                   forHTTPHeaderField: MIMEType.contentType.value)
        request.addValue(User.identifier.rawValue,
                                   forHTTPHeaderField: RequestName.identifier.key)
        
        client.requestData(with: request) { result in
            switch result {
            case .success(_):
                return
            case .failure(_):
                return
            }
        }
    }
}
