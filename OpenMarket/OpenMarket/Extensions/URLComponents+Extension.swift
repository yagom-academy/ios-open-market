//  Created by Aejong, Tottale on 2022/11/15.

import Foundation

extension URLComponents {
    
    mutating func setQueryItems(with parameters: [Query: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key.description, value: $0.value) }
    }
}
