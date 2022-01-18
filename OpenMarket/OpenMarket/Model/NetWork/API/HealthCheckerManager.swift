import Foundation

enum HealthCheckerManager {
    static func request<T: URLSessionProtocol>(session: T, completion: @escaping (Result<Data, NetworkingError>) -> Void) {
        let httpMethod = "GET"
        let urlString = "https://market-training.yagom-academy.kr/healthChecker"

        session.requestDataTask(urlString: urlString,
                                          httpMethod: httpMethod,
                                          httpBody: nil,
                                          headerFields: nil,
                                          completion: completion)
    }
}

