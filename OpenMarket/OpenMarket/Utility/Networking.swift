import Foundation

struct Networking {
    static func fetchGoodsList(page: UInt) {
        guard let listURL = NetworkConfig.makeURL(with: .fetchGoodsList(page: page)) else {
            return
        }
        requestToServer(with: listURL, method: .get, parameter: nil) { (result) in
            do {
                let data = try result.get()
                let json = try self.decodeData(to: MarketGoods.self, from: data)
                debugPrint(json)
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    static func fetchGoods(id: UInt) {
        guard let itemURL = NetworkConfig.makeURL(with: .fetchGoods(id: id)) else {
            return
        }
        requestToServer(with: itemURL, method: .get, parameter: nil) { (result) in
            do {
                let data = try result.get()
                let json = try self.decodeData(to: Goods.self, from: data)
                debugPrint(json)
            } catch let error {
                debugPrint(error)
            }
        }
    }
    
    static func registerGoods(form: RegisterGoodsForm) {
        guard let itemURL = NetworkConfig.makeURL(with: .registerGoods),
              let parameter = try? self.encodeData(form: form) else {
            return
        }
        requestToServer(with: itemURL, method: .post, parameter: parameter) { (result) in
            do {
                let data = try result.get()
                let json = try self.decodeData(to: Goods.self, from: data)
                debugPrint(json)
            } catch let error {
                debugPrint(error)
            }
        }
    }
    
    static func editGoods(form: EditGoodsForm, id: UInt) {
        guard let itemURL = NetworkConfig.makeURL(with: .editGoods(id: id)),
              let parameter = try? self.encodeData(form: form) else {
            return
        }
        requestToServer(with: itemURL, method: .post, parameter: parameter) { (result) in
            do {
                let data = try result.get()
                let json = try self.decodeData(to: MarketGoods.self, from: data)
                debugPrint(json)
            } catch let error {
                debugPrint(error)
            }
        }
    }
    
    static func removeGoods(form: DeleteGoodsForm, id: UInt) {
        guard let itemURL = NetworkConfig.makeURL(with: .removeGoods(id: id)),
              let parameter = try? self.encodeData(form: form) else {
            return
        }
        
        requestToServer(with: itemURL, method: .delete, parameter: parameter) { (result) in
            do {
                let data = try result.get()
                debugPrint(data)
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private static func requestToServer(with url: URL, method: MethodType, parameter: Data?, completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let parameter = parameter {
            request.httpBody = parameter
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
    
    private static func decodeData<T: Decodable>(to type: T.Type, from data: Data) throws -> T {
        let data = try JSONDecoder().decode(type, from: data)
        return data
    }
    
    private static func encodeData<T: Encodable>(form: T) throws -> Data? {
        let data = try JSONEncoder().encode(form)
        return data
    }
}
