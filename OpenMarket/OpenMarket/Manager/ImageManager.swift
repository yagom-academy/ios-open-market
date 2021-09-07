//
//  ImageManager.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/05.
//

import UIKit

struct ImageManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func loadedImage(url: String, compleHandler: @escaping (Result<UIImage, NetworkError>) -> Void) -> URLSessionTask? {
        guard let url = URL(string: url) else {
            compleHandler(.failure(.invalidURL))
            return nil
        }
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) { Data, response, error in
            let result = session.obtainResponseData(data: Data, response: response, error: error)
            switch result {
            case .failure(let error):
                compleHandler(.failure(error))
                return
            case .success(let data):
                guard let imageData = UIImage(data: data) else {
                    compleHandler(.failure(.convertImageFailed))
                    return
                }
                compleHandler(.success(imageData))
            }
        }
        dataTask.resume()
        return dataTask
    }
}
