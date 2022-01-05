import Foundation

class APIManager {
    
    var apiHealth: String?
    var product: OpenMarketPage?
    var productList: OpenMarket?
    let semaphore = DispatchSemaphore(value: 0)
    
    func checkAPIHealth() {
        let request = URLRequest(work: .healthChecker, method: .get)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                self.semaphore.signal()
                return
            }
            self.apiHealth = String(data: data, encoding: .utf8)!
            self.semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func checkProductDetail(from id: Int) {
        let request = URLRequest(work: .checkProductDetail(id: id), method: .get)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                self.semaphore.signal()
                return
            }
            self.product = JSONParser.decodeData(of: data, how: OpenMarketPage.self)
            self.semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func checkProductList() {
        let request = URLRequest(work: .checkProductList, method: .get)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                self.semaphore.signal()
                return
            }
            self.productList = JSONParser.decodeData(of: data, how: OpenMarket.self)
            self.semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
}
