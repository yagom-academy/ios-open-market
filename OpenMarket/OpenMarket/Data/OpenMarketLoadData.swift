//
//  OpenMarketLoadData.swift
//  OpenMarket
//
//  Created by Do Yi Lee on 2021/08/20.
//

import Foundation

struct OpenMarketLoadData {
    //MARK: Request Method
    static func requestOpenMarketMainPageData(page: String, completionHandler: @escaping (OpenMarketItems) -> ()) {
        guard let url = URL(string: String(describing: OpenMarketUrl.listLookUp) + page) else {
            return
        }
        
        NetworkManager.request(httpMethod: .get, url: url, body: nil, .json) { result in
            switch result {
            case .success(let data):
                guard let jsonItem = try? ParsingManager.jsonDecode(data: data, type: OpenMarketItems.self) else {
                    return
                }
                completionHandler(jsonItem)
            case .failure(let error):
                NotificationCenter.default.post(name: .networkError, object: nil, userInfo: ["error":error])
            }
        }
    }
}
