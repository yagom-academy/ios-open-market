//
//  URLSessionManager.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/05/28.
//

import Foundation
class NetworkManager<T: Decodable>: Networkable {
    let clientRequest: GETRequest
    
    init(clientRequest: GETRequest){
        self.clientRequest = clientRequest
    }
}
