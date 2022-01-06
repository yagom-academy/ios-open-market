import Foundation

class APIManager {
    
    var apiHealth: String?
    var product: ProductDetail?
    var productList: ProductList?
    let semaphore = DispatchSemaphore(value: 0)
    
    func checkAPIHealth() {
        guard let url = WorkType.healthChecker.url else { return }
        let request = URLRequest(url: url, method: .get)
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
        guard let url = WorkType.checkProductDetail(id: id).url else { return }
        let request = URLRequest(url: url, method: .get)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                self.semaphore.signal()
                return
            }
            self.product = JSONParser.decodeData(of: data, how: ProductDetail.self)
            self.semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func checkProductList() {
        guard let url = WorkType.checkProductList.url else { return }
        let request = URLRequest(url: url, method: .get)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                self.semaphore.signal()
                return
            }
            self.productList = JSONParser.decodeData(of: data, how: ProductList.self)
            self.semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
}
