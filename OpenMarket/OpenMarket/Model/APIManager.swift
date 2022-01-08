import Foundation

class APIManager {
    
    let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func checkAPIHealth(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URLManager.healthChecker.url else { return }
        let request = URLRequest(url: url, method: .get)
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                completion(.failure(error!))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
    
    func checkProductDetail(id: Int, completion: @escaping (Result<ProductDetail, Error>) -> Void) {
        guard let url = URLManager.checkProductDetail(id: id).url else { return }
        let request = URLRequest(url: url, method: .get)
        creatDataTask(with: request, completion: completion)
    }
    
    func checkProductList(pageNumber: Int, itemsPerPage: Int, completion: @escaping (Result<ProductList, Error>) -> Void) {
        guard let url = URLManager.checkProductList(pageNumber: pageNumber, itemsPerPage: itemsPerPage).url else { return }
        let request = URLRequest(url: url, method: .get)
        creatDataTask(with: request, completion: completion)
    }
    
}

extension APIManager {
    
    func creatDataTask<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(URLSessionError.requestFailed))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode >= 300 {
                completion(.failure(URLSessionError.responseFailed(code: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLSessionError.invaildData))
                return
            }
            guard let decodedData = JSONParser.decodeData(of: data, type: T.self) else {
                completion(.failure(JSONError.dataDecodeFailed))
                return
            }
            completion(.success(decodedData))
        }
        task.resume()
    }
    
}
