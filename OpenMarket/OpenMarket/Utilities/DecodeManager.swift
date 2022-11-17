//  Created by Aejong, Tottale on 2022/11/15.

import UIKit

final class DecodeManger {
    
    static let shared = DecodeManger()
    private let decoder = JSONDecoder()
    
    private init() { }
    
    func fetchData<T: Decodable>(name: String) throws -> T? {
        guard let assetData = NSDataAsset.init(name: name) else { throw DataError.noneDataError }
        guard let itemData = try? decoder.decode(T.self, from: assetData.data) else {
            throw DataError.decodingError
        }
        
        return itemData
    }
    
    func fetchData<T: Decodable>(data: Data) -> T? {
        guard let itemData = try? decoder.decode(T.self, from: data) else {
            return nil
        }
        
        return itemData
    }
}
