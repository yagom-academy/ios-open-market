import Foundation

struct APICaller {
    let openMarketFunction: Networkable
    let completion: Completion
    typealias Completion = (Result<Data, Error>) -> Void
}
