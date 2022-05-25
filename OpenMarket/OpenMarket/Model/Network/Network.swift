//
//  Network.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/20.
//

import Foundation

struct Network: NetworkAble {
    
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}
