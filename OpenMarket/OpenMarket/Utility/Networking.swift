import Foundation

class Networking {
    private let baseURL = "https://camp-open-market.herokuapp.com/"

    func fetchList(page: UInt) {
        guard let listURL = URL(string: "\(baseURL)items/\(page)") else {
            return
        }
        requestToServer(with: listURL, method: .get, parameter: nil) { (result) in
            do {
                let data = try result.get()
                let json = try self.decodeData(to: Market.self, from: data)
                print(json)
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func registerItem(form: RegisterItemForm) {
        guard let itemURL = URL(string: "\(baseURL)item") else {
            return
        }
        requestToServer(with: itemURL, method: .post, parameter: form.convertParameter) { (result) in
            do {
                let data = try result.get()
                print(data)
            } catch let error {
                print(error)
                return
            }
        }
    }
    
    func fetchItem(id: UInt) {
        guard let itemURL = URL(string: "\(baseURL)item/\(id)") else {
            return
        }
        requestToServer(with: itemURL, method: .get, parameter: nil) { (result) in
            do {
                let data = try result.get()
                let json = try self.decodeData(to: Goods.self, from: data)
                print(json)
            } catch let error {
                print(error)
                return
            }
        }
    }
    
    func editItem(form: EditItemForm, id: UInt) {
        guard let itemURL = URL(string: "\(baseURL)item/\(id)") else {
            return
        }
        requestToServer(with: itemURL, method: .post, parameter: form.convertParameter) { (result) in
            do {
                let data = try result.get()
                let json = try self.decodeData(to: Market.self, from: data)
                print(json)
            } catch let error {
                print(error)
                return
            }
        }
    }
    
    func removeItem(form: DeleteItemForm, id: UInt) {
        guard let itemURL = URL(string: "\(baseURL)item/\(id)") else {
            return
        }
        
        requestToServer(with: itemURL, method: .delete, parameter: form.convertParameter) { (result) in
            do {
                let data = try result.get()
                print(data)
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    private func requestToServer(with url: URL, method: MethodType, parameter: [String: Any]?, completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let parameter = parameter {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameter)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                return completion(.failure(NetworkError.response))
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                return completion(.failure(NetworkError.response))
            }
            
            guard let data = data else {
                return completion(.failure(NetworkError.data))
            }
            
            return completion(.success(data))
        }.resume()
    }
    
    private func decodeData<T: Decodable>(to type: T.Type, from data: Data) throws -> T {
        let data = try JSONDecoder().decode(type, from: data)
        return data
    }
}
