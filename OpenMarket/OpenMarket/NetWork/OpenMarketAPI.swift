//
//  OenMarketAPI.swift
//  OpenMarket
//
//  Created by sole on 2021/01/26.
//

import Foundation

final class OpenMarketAPI {
    
    weak var delegate: OpenMarketAPIDelegate?
    private var session = URLSession(configuration: .default) // TODO: configuration을 .default로 해야하는 이유는?
    private var decoder = JSONDecoder()
    
    private func decodeData<T>(_ data: Data, type: T.Type) -> T? where T : Decodable {
        let decodedData = try? self.decoder.decode(type, from: data)
        return decodedData
    }
    
    func getItems(page: Int) {
        guard let delegate = delegate else {
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
            
            guard let data = data else {
                print("No Data Error")
                return
            }
            
            guard let items = self.decodeData(data, type: ItemToGet.self) else {
                print("Data Decoding Error")
                return
            }
            
            delegate.setItems(items)
        }.resume()
    }
    
}
