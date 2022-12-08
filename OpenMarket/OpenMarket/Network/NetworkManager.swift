//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/15.
//

import UIKit

final class NetworkManager {
    let session: URLSessionProtocol
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - checkHealth
    func checkHealth(to url: URL, completion: @escaping (Result<Int, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.GET
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.networking))
                return
            }
            
            guard data != nil else {
                completion(.failure(.data))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  200 == response.statusCode else {
                completion(.failure(.networking))
                return
            }
            
            let responseData = response.statusCode
            completion(.success(responseData))
        }.resume()
    }
    
    // MARK: - Fetch Data
    func fetchData<T: Decodable>(to url: URL,
                                 dataType: T.Type,
                                 completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        let decodeManager = DecodeManager<T>()
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.GET
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.networking))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.data))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200 ..< 299) ~= response.statusCode else {
                completion(.failure(.networking))
                return
            }
            
            let productData = decodeManager.decodeData(data: safeData)
            
            switch productData {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchImage(with stringURL: String, completionHandler: @escaping (UIImage) -> Void) {
        guard let imageURL = URL(string: stringURL) else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: imageURL),
                  let image = UIImage(data: data) else { return }
            
            completionHandler(image)
        }
    }
    
    // MARK: - Post NewData
    func postData(to url: URL,
                  newData: (productData: NewProduct, images: [UIImage?]),
                  completion: @escaping (Result<Bool, NetworkError>) -> Void)  {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(newData.productData) else { return }
        let boundary = generateBoundaryString()

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.POST
        request.settingIdentifier()
        request.addValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        
        var httpBody = Data()
        httpBody.append(convertDataForm(named: "params", value: data, boundary: boundary))
        
        for image in newData.images {
            guard let image = image, let imageData =
                    image.resize(expectedSizeInKb: 300) else { return }
            httpBody.append(convertFileDataForm(fieldName: "images",
                                                fileName: "imagesName",
                                                mimeType: "multipart/form-data",
                                                fileData: imageData,
                                                boundary: boundary))
        }
        
        httpBody.appendStringData("--\(boundary)--")
        request.httpBody = httpBody
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.networking))
                return
            }
            
            guard data != nil else {
                completion(.failure(.data))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200 ..< 299) ~= response.statusCode else {
                completion(.failure(.networking))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    // MARK: - Patch Data
    func patchData(url: URL,
                     updateData: NewProduct,
                     completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(updateData) else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = HttpMethod.PATCH
        request.settingIdentifier()
        request.addValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        
        request.httpBody = data
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.networking))
                return
            }
            
            guard data != nil else {
                completion(.failure(.data))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200 ..< 299) ~= response.statusCode else {
                completion(.failure(.networking))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
        
    // MARK: - Fetch Delete Item URI
    private func fetchDeleteDataURI(to url: URL,
                                    completion: @escaping (Result<String, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        
        request.httpMethod = HttpMethod.POST
        request.settingIdentifier()
        request.addValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        
        let bodyData = try? JSONSerialization.data(withJSONObject: ["secret": "dk9r294wvfwkgvhn"])
        request.httpBody = bodyData

        session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.data))
                return
            }
            
            guard let deleteURI = String(data: data, encoding: .utf8) else {
                completion(.failure(.networking))
                return
            }
            
            completion(.success(deleteURI))
        }.resume()
    }
    
    // MARK: - Delete Item Using URI
    func deleteProduct(to url: URL, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        fetchDeleteDataURI(to: url) { result in
            let deleteURL : URL?
            switch result {
            case .success(let uri):
                deleteURL = NetworkRequest.deleteData(uri: uri).requestURL
            case .failure(let error):
                completion(.failure(error))
                return
            }
            
            guard let deleteURL = deleteURL else {
                completion(.failure(.unknown))
                return
            }
            
            var request = URLRequest(url: deleteURL)
            request.httpMethod = HttpMethod.DELETE
            request.settingIdentifier()
            
            self.session.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    completion(.failure(.networking))
                    return
                }
                
                guard data != nil else {
                    completion(.failure(.data))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200 ..< 299) ~= response.statusCode else {
                    completion(.failure(.networking))
                    return
                }
                
                completion(.success(true))
            }.resume()
        }
    }
}

// MARK: - Assist Make Multipart Data Form
extension NetworkManager {
    private func generateBoundaryString() -> String {
            return "Boundary-\(UUID().uuidString)"
        }
    
    private func convertDataForm(named name: String, value: Data, boundary: String) -> Data {
        var data = Data()
        data.appendStringData("--\(boundary)\r\n")
        data.appendStringData("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        data.appendStringData("\r\n")
        data.append(value)
        data.appendStringData("\r\n")
        return data
    }
     
    private func convertFileDataForm(fieldName: String,
                                     fileName: String,
                                     mimeType: String,
                                     fileData: Data,
                                     boundary: String) -> Data {
        var data = Data()
        data.appendStringData("--\(boundary)\r\n")
        data.appendStringData("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendStringData("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendStringData("\r\n")
        return data
    }
}

// MARK: - Extension
extension Data {
    mutating func appendStringData(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.append(data)
    }
}

extension URLRequest {
    mutating func settingIdentifier() {
        self.setValue("0574c520-6942-11ed-a917-43299f97bee6",
                      forHTTPHeaderField: "identifier")
    }
}
