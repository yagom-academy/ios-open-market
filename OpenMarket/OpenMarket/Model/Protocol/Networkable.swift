import Foundation

protocol Networkable {
    static var baseURLString: String { get }
    static var httpMethod: HttpMethod { get }
    var url: URL? { get }
    func request() 
}

