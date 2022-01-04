import Foundation

class APIManager {
    let apiHost = "https://market-training.yagom-academy.kr/"
    var healthChecker: String?
    var product: ProductInformation?
    var semaphore = DispatchSemaphore (value: 0)
    
    func requestHealthChecker() {
        let url = apiHost + "healthChecker"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                self.semaphore.signal()
                
                return
            }
            
            self.healthChecker = String(data: data, encoding: .utf8)!
            self.semaphore.signal()
        }
        
        task.resume()
        self.semaphore.wait()
    }
    
    func requestProductInformation(productID: Int) {
        let url = apiHost + "/api/products/" + "\(productID)"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                self.semaphore.signal()
                
                return
            }
            
            do {
                self.product = try Parser.decode(from: data)
            } catch {
                print(error)
            }
            
            self.semaphore.signal()
        }
        
        task.resume()
        self.semaphore.wait()
    }
}
