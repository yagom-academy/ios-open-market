import Foundation

class Networking {
    private let baseURL = "https://camp-open-market.herokuapp.com/"

    func fetchGoodsList(page: UInt) {
        guard let listURL = NetworkConfig.makeURL(with: .fetchGoodsList(page: page)) else {
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
    
    func registerGoods(form: RegisterItemForm) {
        guard let itemURL = NetworkConfig.makeURL(with: .registerGoods) else {
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
    
    func fetchGoods(id: UInt) {
        guard let itemURL = NetworkConfig.makeURL(with: .fetchGoods(id: id)) else {
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
    
    func editGoods(form: EditItemForm, id: UInt) {
        guard let itemURL = NetworkConfig.makeURL(with: .editGoods(id: id)) else {
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
    
    func removeGoods(form: DeleteItemForm, id: UInt) {
        guard let itemURL = NetworkConfig.makeURL(with: .removeGoods(id: id)) else {
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
