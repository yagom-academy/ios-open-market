import Foundation

protocol APIService {
    func doDataTask(
        with request: URLRequest,
        session: URLSessionProtocol,
        completionHandler: @escaping (Result<Data, NetworkingError>) -> Void
    )
}

extension APIService {
    func doDataTask(
        with request: URLRequest,
        session: URLSessionProtocol,
        completionHandler: @escaping (Result<Data, NetworkingError>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completionHandler(.failure(.request))
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                return completionHandler(.failure(.response))
            }
            guard let data = data else {
                return completionHandler(.failure(.data))
            }
            completionHandler(.success(data))
        }
        task.resume()
    }

    func checkNetworkConnection(
        session: URLSessionProtocol,
        completionHandler: @escaping ((Result<Data, NetworkingError>) -> Void)
    ) {
        let urlString = "\(HTTPUtility.baseURL)/healthChecker"
        guard let request = HTTPUtility.urlRequest(urlString: urlString) else {
            return
        }
        doDataTask(with: request, session: session) { result in
            completionHandler(result)
        }
    }
}
