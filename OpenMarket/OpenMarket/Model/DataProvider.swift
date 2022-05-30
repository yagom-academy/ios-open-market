//
//  DataProvider.swift
//  OpenMarket
//
//  Created by papri, Tiana on 19/05/2022.
//

import UIKit

class DataProvider {
    private var pageNumber = 1
    private let itemsPerPage = 10
    private var isLoading = false
    
    func reloadData(completionHandler: @escaping ([Product]?) -> Void) {
        pageNumber = 1
        fetchProductListData(completionHandler: completionHandler)
    }
    
    func patchProductData(prductIdentifier: Int, productInput: [String: Any], completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        HTTPManager().patchData(product: productInput, targetURL: .productPatch(productIdentifier: prductIdentifier)) { data in
            completionHandler(data)
        }
    }
    
    func postProductData(images: [UIImage], productInput: [String: Any], completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        HTTPManager().postProductData(images: images, product: productInput, completionHandler: completionHandler)
    }
    
    func fetchProductDetailData(productIdentifier: Int, completionHandler: @escaping (ProductDetail?) -> Void) {
        HTTPManager().loadData(targetURL: .productDetail(productNumber: productIdentifier)) { [self] data in
            switch data {
            case .success(let data):
                guard let product = try? JSONDecoder().decode(ProductDetail.self, from: data) else { return }
                completionHandler(product)
            case .failure(_):
                completionHandler(nil)
            }
        }
    }
    
    func fetchProductListData(completionHandler: @escaping ([Product]?) -> Void) {
        if isLoading {
            return
        }
        
        if pageNumber > 33 {
            return
        }
        
        isLoading = true
        HTTPManager().loadData(targetURL: .productList(pageNumber: pageNumber, itemsPerPage: itemsPerPage)) { [self] data in
            switch data {
            case .success(let data):
                guard let products = try? JSONDecoder().decode(OpenMarketProductList.self, from: data).products else { return }
                completionHandler(products)
                pageNumber += 1
                isLoading = false
            case .failure(_):
                completionHandler(nil)
            }
        }
    }
    
    func fetchImage(urlString: String, completionHandler: @escaping (UIImage) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return
            }
            if let data = data,
               let image = UIImage(data: data) {
                completionHandler(image)
                return
            }
        }
        task.resume()
        return task
    }
}
