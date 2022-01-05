import Foundation

class APIManager {
    
    var apiHealth: String?
    var product: OpenMarketPage?
    var productList: OpenMarket?
    let semaphore = DispatchSemaphore(value: 0)
    
    func checkAPIHealth() {
        var request = URLRequest(url: URLManager.healthChecker.url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
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
        var request = URLRequest(url: URLManager.checkProductDetail(id: id).url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
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
        var request = URLRequest(url: URLManager.checkProductList.url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
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
