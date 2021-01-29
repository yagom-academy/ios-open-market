import Foundation

struct Networking {
    static func makeRequest(api: OpenMarketAPITypes, with pathParameter: UInt? = nil) throws -> URLRequest? {
        guard let url = NetworkConfig.makeURL(api: api, with: pathParameter) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = api.choiceHTTPMethod().rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    static func makeRequestWithGoodsForm(api: OpenMarketAPITypes, with form: GoodsForm) throws -> URLRequest? {
        guard let url = NetworkConfig.makeURL(api: api, with: form.id) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = api.choiceHTTPMethod().rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = try JSONEncoder().encode(form)
        request.httpBody = data
        
        return request
    }
    
    static func requestToServer<T: Decodable>(with request: URLRequest, dataType: T.Type, completion: @escaping ((Result<T, Error>) -> Void)) {
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
            
            do {
                let data = try JSONDecoder().decode(dataType, from: data)
                return completion(.success(data))
            } catch {
                return completion(.failure(OpenMarketError.convertData))
            }
        }.resume()
    }
}
