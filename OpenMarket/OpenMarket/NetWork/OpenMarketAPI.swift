//
//  OenMarketAPI.swift
//  OpenMarket
//
//  Created by sole on 2021/01/26.
//

import Foundation

protocol OpenMarketAPIDelegate: class {
    func didGetItems(_ items: ItemToGet)
}

final class OpenMarketAPI {
    
    weak var delegate: OpenMarketAPIDelegate?
    private var session = URLSession(configuration: .default)
    
    func getItems(page: Int) {
        guard let delegate = delegate else {
            print("no delegate")
            return
        }
        
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
                print("error")
                return
            }
            
            guard let data = data else {
                print("No Data Error")
                return
            }
     
            guard let items =  Parser.decodeData(ItemToGet.self, data) else {
                print("Data Decoding Error")
                return
            }
            
            delegate.didGetItems(items)
        }.resume()
    }
}
