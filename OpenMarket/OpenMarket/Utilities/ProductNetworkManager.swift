//  Created by Aejong, Tottale on 2022/11/30.

import UIKit

final class ProductNetworkManager {
    private let networkProvider = NetworkAPIProvider()
    static let shared = ProductNetworkManager()
    private init() {}
    
    func fetchProductList(completion: @escaping (Result<ProductList, Error>) -> Void) {
        networkProvider.fetch(url: NetworkAPI.products(query: [.itemsPerPage: "200"]).urlComponents.url) { result in
            switch result {
            case .success(let data):
                guard let productList: ProductList = JSONDecoder().decode(data: data) else {
                    completion(.failure(NetworkError.decodeFailed))
                    return
                }
                completion(.success(productList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postNewProduct(params: NewProductInfo,
                        images: [UIImage],
                        completion: @escaping (Result<Product, Error>) -> Void) {
        let boundary: String = "Boundary-\(UUID().uuidString)"
        guard let url = NetworkAPI.products(query: nil).urlComponents.url else { return }
        let request = generatePostRequest(url: url, boundary: boundary, params: params, images: images)
        
        networkProvider.post(request: request) { result in
            switch result {
            case .success(let data):
                guard let product: Product = JSONDecoder().decode(data: data) else {
                    completion(.failure(NetworkError.decodeFailed))
                    return
                }
                completion(.success(product))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func generatePostRequest(url: URL,
                                 boundary: String,
                                 params: NewProductInfo,
                                 images: [UIImage]) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("40343fb3-6941-11ed-a917-7be94b1381ef", forHTTPHeaderField: "identifier")
        request.setValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
        request.httpBody = createBody(boundary, params, images)
        
        return request
    }
    
    
    private func createBody(_ boundary: String, _ params: NewProductInfo, _ images: [UIImage]) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"params\"\(lineBreak + lineBreak)")
        let json = try! JSONEncoder().encode(params)
        body.append(json)
        body.append(lineBreak)
        
        for image in images {
            if let uuid = UUID().uuidString.components(separatedBy: "-").first {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(uuid).jpeg\"\(lineBreak)")
                body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
                body.append(image.compress(to: 300))
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
}
