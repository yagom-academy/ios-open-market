import Foundation

protocol DataStorable {
    var storage: Decodable? { get set }
//    var requester: Requestable? { get set }
}
