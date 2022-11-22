//
//  OpenMarket - NetworkRequestable.swift
//  Created by Zhilly, Dragon. 22/11/15
//  Copyright © yagom. All rights reserved.
//

import Foundation

protocol NetworkRequestable {
    func request<T: Decodable>(from url: URL?,
                 httpMethod: HttpMethod,
                 dataType: T.Type,
                 completion: @escaping (Result<T,NetworkError>) -> Void)
}
