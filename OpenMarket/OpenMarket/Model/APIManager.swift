import Foundation

class APIManager {
    
    let apiHost: String = "https://market-training.yagom-academy.kr/"
    var apiStatus: String = "ㅁㅁㅁ"
    let semaphore = DispatchSemaphore(value: 0)
    
    func healthChecker() {
        let url: String = apiHost + "healthChecker"
        var request = URLRequest(url: URL(string: url)!, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                self.semaphore.signal()
                return
            }
            self.apiStatus = String(data: data, encoding: .utf8)!
            self.semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
}
