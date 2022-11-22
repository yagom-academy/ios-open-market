//  Created by Aejong, Tottale on 2022/11/15.


import Foundation

extension JSONDecoder {
    func decode<T: Decodable>(data: Data) -> T? {
        guard let itemData = try? self.decode(T.self, from: data) else {
            return nil
        }
        
        return itemData
    }
}
