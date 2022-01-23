import Foundation

protocol APIRequestable {
    var url: URL? { get }
    var httpMethod: HTTPMethod { get }
    var httpBody: Data? { get }
    var headerFields: [String: String]? { get }
}
