import Foundation

class Networking {
    private let baseURL = "https://camp-open-market.herokuapp.com/"
    private var request: URLRequest?

    func fetchList(page: UInt) {
        guard let listURL = URL(string: "\(baseURL)items/\(page)") else {
            return
        }
        request = URLRequest(url: listURL)
        request?.httpMethod = "GET"
        requestWithGetMethod(with: request, parameter: nil) { (result) in
            do {
                let data = try result.get()
                let json = try self.decodeData(to: Market.self, from: data)
                print(json)
            } catch {
                return
            }
        }
    }
    
    func registerItem(item: Item) {
        guard let itemURL = URL(string: "\(baseURL)item") else {
            return
        }
        request = URLRequest(url: itemURL)
        request?.httpMethod = "POST"
        request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestWithGetMethod(with: request, parameter: nil) { (result) in
            do {
                let data = try result.get()
                let json = try self.decodeData(to: Market.self, from: data)
                print(json)
            } catch {
                return
            }
        }
    }
    
    func fetchItem(id: UInt) {
        guard let itemURL = URL(string: "\(baseURL)item/\(id)") else {
            return
        }
        request = URLRequest(url: itemURL)
        request?.httpMethod = "GET"
        requestWithGetMethod(with: request, parameter: nil) { (result) in
            do {
                let data = try result.get()
                let json = try self.decodeData(to: Item.self, from: data)
                print(json)
            } catch {
                return
            }
        }
    }
    
    func editItem(id: UInt) {
        guard let itemURL = URL(string: "\(baseURL)item/\(id)") else {
            return
        }
        request = URLRequest(url: itemURL)
        request?.httpMethod = "POST"
        request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestWithGetMethod(with: request, parameter: nil) { (result) in
            do {
                let data = try result.get()
                let json = try self.decodeData(to: Market.self, from: data)
                print(json)
            } catch {
                return
            }
        }
    }
    
    func removeItem(id: UInt) {
        guard let itemURL = URL(string: "\(baseURL)item/\(id)") else {
            return
        }
        request = URLRequest(url: itemURL)
        request?.httpMethod = "DELETE"
        requestWithGetMethod(with: request, parameter: nil) { (result) in
            do {
                let data = try result.get()
                let json = try self.decodeData(to: Market.self, from: data)
                print(json)
            } catch {
                return
            }
        }
    }
    
    private func requestWithGetMethod(with request: URLRequest?, parameter: [String: Any]?, completion: @escaping ((Result<Data, Error>) -> Void)) {
        guard var request = request else {
            return
        }
        
        if let parameter = parameter {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameter)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error != nil else {
                return completion(.failure(NetworkError.requestError))
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                return completion(.failure(NetworkError.responseError))
            }
            
            guard let data = data else {
                return completion(.failure(NetworkError.dataError))
            }
            return completion(.success(data))
        }.resume()
    }
    
    private func decodeData<T: Decodable>(to type: T.Type, from data: Data) throws -> T {
        let data = try JSONDecoder().decode(type, from: data)
        return data
    }
}
