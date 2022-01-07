//
//  MarketAPIService.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/01/05.
//

import Foundation

final class MarketAPIService {
    private let session: DataTaskProvidable
    private let successRange = 200..<300
    
    init(session: DataTaskProvidable = URLSession.shared) {
        self.session = session
    }
}

//MARK: - Namespace

extension MarketAPIService {
    private enum MarketAPI {
        static let baseURL = "https://market-training.yagom-academy.kr"
        static let path = "/api/products/"
        
        case postProduct
        case patchProduct(id: Int)
        case postSecret(id: Int)
        case delete(id: Int, secret: String)
        case getProduct(id: Int)
        case getPage(pageNumber: Int, itemsPerPage: Int)
        
        var url: URL? {
            switch self {
            case .postProduct:
                return URL(string: MarketAPI.baseURL + MarketAPI.path)
            case .patchProduct(let id):
                return URL(string: MarketAPI.baseURL + MarketAPI.path + id.stringFormat)
            case .postSecret(let id):
                return URL(string: MarketAPI.baseURL + MarketAPI.path + id.stringFormat + "/secret")
            case .delete(let id, let secret):
                return URL(string: MarketAPI.baseURL + MarketAPI.path + id.stringFormat + "/" + secret)
            case .getProduct(let id):
                return URL(string: MarketAPI.baseURL + MarketAPI.path + id.stringFormat)
            case .getPage(let id, let itemsPerPage):
                guard var urlComponents = URLComponents(string: MarketAPI.baseURL) else {
                    return nil
                }
                let pageNumberQuery = URLQueryItem(name: "page_no", value: id.stringFormat)
                let itemsPerPageQuery = URLQueryItem(name: "items_per_page", value: itemsPerPage.stringFormat)
                
                urlComponents.queryItems = [pageNumberQuery, itemsPerPageQuery]
                
                return urlComponents.url
            }
        }
    }
}

//MARK: - APIServiceable 프로토콜 채택

extension MarketAPIService: APIServicable {
    func post(product: PostProduct, images: [Data], completionHandler: @escaping (Result<Data, APIError>) -> Void) {
        
    }
    
    func patch(productID: Int, product: PatchProduct) {
        
    }
    
    func post(productID: Int, secret: String) {
        
    }
    
    func delete(productID: Int, productSecret: String) {
        
    }
    
    func get(productID: Int, completionHandler: @escaping (Result<Product, APIError>) -> Void) {
        guard let url = MarketAPI.getProduct(id: productID).url else {
            return
        }
        let request = URLRequest(url: url)
        performDataTask(request: request, completionHandler: completionHandler)
    }
    
    func get(pageNumber: Int, itemsPerPage: Int, completionHandler: @escaping (Result<Page, APIError>) -> Void) {
        guard let url = MarketAPI.getPage(pageNumber: pageNumber, itemsPerPage: itemsPerPage).url else {
            return
        }
        let request = URLRequest(url: url)
        performDataTask(request: request, completionHandler: completionHandler)
    }
}

//MARK: - MarketAPIService 메서드

extension MarketAPIService {
    private func performDataTask<T: Decodable>(request: URLRequest,
                                              completionHandler: @escaping (Result<T, APIError>) -> Void) {
        let dataTask = session.dataTask(with: request) { [unowned self] data, response, error in
            guard error == nil else {
                completionHandler(.failure(APIError.invalidHTTPMethod))
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  self.successRange.contains(statusCode) else {
                completionHandler(.failure(APIError.invalidRequest))
                return
            }
            guard let data = data else {
                completionHandler(.failure(APIError.noData))
                return
            }
            guard let parsedData = parse(with: data, type: T.self) else {
                return
            }
            
            completionHandler(.success(parsedData))
        }
        
        dataTask.resume()
    }
}

