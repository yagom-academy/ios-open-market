import Foundation

class APIManager {
    
    let apiHost: String = "https://market-training.yagom-academy.kr/"
    var apiHealth: String?
    var product: OpenMarketPage?
    var productList: OpenMarket?
    let semaphore = DispatchSemaphore(value: 0)
    
    func checkAPIHealth() {
        let url: String = apiHost + "healthChecker"
        var request = URLRequest(url: URL(string: url)!, timeoutInterval: Double.infinity)
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
        let url: String = apiHost + "api/products/" + "\(id)"
        var request = URLRequest(url: URL(string: url)!, timeoutInterval: Double.infinity)
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
        let url: String = apiHost + "api/products?page-no=1&items-per-page=10"
        var request = URLRequest(url: URL(string: url)!, timeoutInterval: Double.infinity)
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
