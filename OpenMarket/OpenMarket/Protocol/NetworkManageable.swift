//
//  NetworkManageable.swift
//  OpenMarket
//
//  Created by James on 2021/06/01.
//

import Foundation

protocol NetworkManageable {
    var urlSession: URLSessionProtocol { get }
    var isReadyToPaginate: Bool { get set }
    var boundary: String { get }
    
    func getItemList(page: Int, loadingFinished: Bool, completionHandler: @escaping (_ result: Result <OpenMarketItemList, Error>) -> Void)
}
extension NetworkManageable {
    func examineNetworkResponse(page: Int, completionHandler: @escaping (_ result: Result <HTTPURLResponse, Error>) -> Void) {
        guard let url = URL(string: "\(OpenMarketAPI.urlForItemList)\(page)") else {
            return completionHandler(.failure(NetworkResponseError.badRequest))
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = HTTPMethods.get.rawValue
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            if let dataError = error {
                completionHandler(.failure(NetworkResponseError.noData))
                print(dataError.localizedDescription)
            }
            if let urlResponse = response as? HTTPURLResponse {
                let urlResponseResult = self.handleNetworkResponseError(urlResponse)
                switch urlResponseResult {
                case .failure(let errorDescription):
                    print(errorDescription)
                    return completionHandler(.failure(NetworkResponseError.badRequest))
                case .success:
                    completionHandler(.success(urlResponse))
                }
            }
        }.resume()
    }

    func examineNetworkRequest(page: Int, completionHandler: @escaping (_ result: Result <URLRequest, Error>) -> Void) {
        guard let url = URL(string: "\(OpenMarketAPI.urlForItemList)\(page)") else {
            return completionHandler(.failure(NetworkResponseError.badRequest))
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = HTTPMethods.get.rawValue
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            if let dataError = error {
                completionHandler(.failure(NetworkResponseError.noData))
                print(dataError.localizedDescription)
            }
            if let urlResponse = response as? HTTPURLResponse {
                let urlResponseResult = self.handleNetworkResponseError(urlResponse)
                switch urlResponseResult {
                case .failure(let errorDescription):
                    print(errorDescription)
                    return completionHandler(.failure(NetworkResponseError.badRequest))
                case .success:
                    completionHandler(.success(urlRequest))
                }
            }
        }.resume()
    }
    
    func handleNetworkResponseError(_ response: HTTPURLResponse) -> NetworkResponseResult<String> {
        switch response.statusCode {
        case 200...299:
            return .success
        case 401...500:
            return .failure(NetworkResponseError.authenticationError.description)
        case 501...599:
            return .failure(NetworkResponseError.badRequest.description)
        case 600:
            return .failure(NetworkResponseError.outdated.description)
        default:
            return .failure(NetworkResponseError.failed.description)
        }
    }
}

// MARK: - Multipart/form-data

extension NetworkManageable {
    func convertTextField(key: String, value: String, boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
          fieldString += "Content-Disposition: form-data; name=\"\(key)\"\r\n"
          fieldString += "\r\n"
          fieldString += "\(value)\r\n"

          return fieldString
    }
    
    func convertFileData(key: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
      let data = NSMutableData()

      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n")
      data.appendString("Content-Type: \(mimeType)\r\n\r\n")
      data.append(fileData)
      data.appendString("\r\n")

      return data as Data
    }
}
