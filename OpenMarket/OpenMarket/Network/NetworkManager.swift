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
                print(NetworkError.networking.description)
                completion(.failure(.networking))
                return
            }
            
            guard data != nil else {
                print(NetworkError.data.description)
                completion(.failure(.data))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  200 == response.statusCode else {
                print(NetworkError.networking.description)
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
            guard let image = image, let imageData = image.jpegData(compressionQuality: 0.5) else { return }
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
    func patchData(to url: URL) {
        var request = URLRequest(url: url)
        
        request.httpMethod = HttpMethod.PATCH
        request.settingIdentifier()
        request.addValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        let bodyData = try? JSONSerialization.data(withJSONObject: ["stock": 777,
                                                                    "product_id": 999,
                                                                    "name": "치킨999",
                                                                    "description": "JMT999",
                                                                    "discounted_price": 0,
                                                                    "price": 99999,
                                                                    "currency": "KRW",
                                                                    "secret":"dk9r294wvfwkgvhn"])
        
        request.httpBody = bodyData
        session.dataTask(with: request) { data, response, error in
            print(String(data: data!, encoding: .utf8))
        }.resume()
    }
        
    // MARK: - Fetch Delete Item URI
    private func fetchDeleteDataURI(to url: URL, completionHandler: @escaping (String)-> Void) {
        var request = URLRequest(url: url)
        
        request.httpMethod = HttpMethod.POST
        request.settingIdentifier()
        request.addValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        
        let bodyData = try? JSONSerialization.data(withJSONObject: ["secret": "dk9r294wvfwkgvhn"])
        request.httpBody = bodyData

        session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            
            guard let deleteURI = String(data: data, encoding: .utf8) else { return }
            completionHandler(deleteURI)
        }.resume()
    }
    
    // MARK: - Delete Item Using URI
    func deleteProduct(to url: URL) {
        fetchDeleteDataURI(to: url) { deleteURI in
            guard let deleteURL = NetworkRequest.deleteData(uri: deleteURI).requestURL else { return }
            var request = URLRequest(url: deleteURL)
            request.httpMethod = HttpMethod.DELETE
            request.settingIdentifier()
               
            self.session.dataTask(with: request) { data, response, error in
                print(String(data: data!, encoding: .utf8))
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
