//
//  APIServicable.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/04.
//

import Foundation

protocol APIServicable: JSONParsable {
    func registerProduct(product: PostProduct, images: [ProductImage], completionHandler: @escaping (Result<Product, APIError>) -> Void)
    func updateProduct(productID: Int, product: PatchProduct, completionHandler: @escaping (Result<Product, APIError>) -> Void)
    func getSecret(productID: Int, password: Password, completionHandler: @escaping (Result<String, APIError>) -> Void)
    func deleteProduct(productID: Int, productSecret: String, completionHandler: @escaping (Result<ProductDetails, APIError>) -> Void)
    func fetchProduct(productID: Int, completionHandler: @escaping (Result<ProductDetails, APIError>) -> Void)
    func fetchPage(pageNumber: Int, itemsPerPage: Int, completionHandler: @escaping (Result<Page, APIError>) -> Void) 
}

