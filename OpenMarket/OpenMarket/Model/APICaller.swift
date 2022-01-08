import Foundation

struct APICaller {
    let openMarketFunction: Networkable
    
    func request() {
        openMarketFunction.request()
    }
}
