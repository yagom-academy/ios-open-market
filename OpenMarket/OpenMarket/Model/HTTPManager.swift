//
//  HTTPManager.swift
//  OpenMarket
//
//  Created by papri, Tiana on 10/05/2022.
//

import Foundation

enum TargetURL {
    case productList(pageNumber: Int, itemsPerPage: Int)
    case productDetail(productNumber: Int)
    
    var string: String {
        switch self {
        case .productList(let pageNumber, let itemsPerPage):
            return "/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)"
        case .productDetail(let productNumber):
            return "/api/products/\(productNumber)"
        }
    }
}

struct HTTPManager {
    private let hostURL: String
    private let urlSession: URLSessionProtocol
    
    init(hostURL: String = "https://market-training.yagom-academy.kr/", urlSession: URLSessionProtocol = URLSession.shared) {
        self.hostURL = hostURL
        self.urlSession = urlSession
    }
    
    func loadData(targetURL: TargetURL, completionHandler: @escaping (Data) -> Void) {
        let requestURL = hostURL + targetURL.string
        guard let url = URL(string: requestURL) else {
            return
        }
        let task = urlSession.dataTask(with: url) { data, response, error in
            if let _ = error {
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200 ... 299).contains(httpResponse.statusCode) else {
                return
            }
            if let mimeType = httpResponse.mimeType,
               mimeType == "application/json",
               let data = data {
                completionHandler(data)
            }
        }
        task.resume()
    }
}
