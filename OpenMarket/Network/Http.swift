//
//  Http.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/17.
//

import Foundation

protocol Http {
    func getItems(
        pageIndex: UInt,
        completionHandler: @escaping (Result<ItemList, HttpError>) -> Void
    )
    
    func getItem(
        id: UInt,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    )
}


extension Http {
    func postItem(_ item: Item){
        let baseURL = HttpConfig.baseURL + HttpMethod.post.type
        
        
        guard let url = URL(string: baseURL) else {
            return
        }
        
        let boundary = HttpConfig.bounday
        var request = URLRequest(url: url)
        
        request.httpMethod = HttpMethod.post.type
    }
    
    func patchItem(_ item: Item){
        
    }
    
    func deleteItem(password: String){
        
    }
}
