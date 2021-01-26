//
//  OenMarketAPI.swift
//  OpenMarket
//
//  Created by sole on 2021/01/26.
//

import Foundation

class OpenMarketAPI {
    
    private static var session = URLSession(configuration: .default)
    
    static func getItemList(page: Int, _ completionHandler: @escaping (ItemsToGet) -> Void) {
        guard let url = URLManager.makeURL(type: .getList, value: page) else {
            print("URL Error")
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let successRange =  200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                print("Status Code Error")
                return
            }
            
            guard let data = data else {
                print("No Data Error")
                return
            }
     
            guard let items = Parser.decodeData(ItemsToGet.self, data) else {
                print("Data Decoding Error")
                return
            }
            
            completionHandler(items)
        }.resume()
    }
    
    static func postItem(itemToPost: ItemToPost, _ completionHandler: @escaping (ItemToGet) -> Void) {
        
    }
}
