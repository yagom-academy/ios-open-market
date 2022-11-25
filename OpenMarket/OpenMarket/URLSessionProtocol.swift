//  Created by Aejong, Tottale on 2022/11/17.

import Foundation

protocol URLSessionProtocol {
    
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
extension URLSession: URLSessionProtocol {}
