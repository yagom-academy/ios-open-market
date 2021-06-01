//
//  URLSessionManager.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/05/28.
//

import Foundation

struct URLSessionManager {
    let clientRequest: ClientRequest
    let urlSessionForGet = URLSession()
    
    init(clientRequest: ClientRequest, urlRequest: URLRequest){
        self.clientRequest = clientRequest
    }
    
    func getServerData(){
        urlSessionForGet.dataTask(with: clientRequest.urlRequest){ data, response, error in
            
        }
    }
}
