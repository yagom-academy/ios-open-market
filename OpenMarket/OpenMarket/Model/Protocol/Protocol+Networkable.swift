import Foundation

protocol Networkable {
    func creatURL()
    func creatURLRequest(httpMethod: HttpMethod, url: URL) -> URLRequest
    func request() 
}
