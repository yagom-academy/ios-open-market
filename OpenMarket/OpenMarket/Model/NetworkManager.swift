//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/16.
//

import Foundation

struct NetworkManager {
    public static let publicNetworkManager = NetworkManager()
    
    func getItemListData(completion: @escaping (ItemList?) -> Void) {
        HTTPManager.requestGet(url: OpenMarketURL.base + OpenMarketURLComponent.itemPageComponent(pageNo: 1, itemPerPage: 100).url) { data in
            guard let data: ItemList = JSONConverter.decodeData(data: data) else {
                return
            }
            
            completion(data)
        }
    }
    
    func getItemData(completion: @escaping (Item?) -> Void) {
        HTTPManager.requestGet(url: OpenMarketURL.base + OpenMarketURLComponent.productComponent(productID: 32).url) { data in
            guard let data: Item = JSONConverter.decodeData(data: data) else {
                return
            }
            
            completion(data)
        }
    }
}
