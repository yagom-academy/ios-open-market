import Foundation

class APIManager {
    
    let apiHost: String = "https://market-training.yagom-academy.kr/"
    var apiHealth: String?
    var product: OpenMarketPage?
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
            do {
                let convertedData = try JSONParser.decodeData(of: data, how: OpenMarketPage.self)
                self.product = convertedData
            } catch {
                print(error.localizedDescription)
            }
            self.semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
}
