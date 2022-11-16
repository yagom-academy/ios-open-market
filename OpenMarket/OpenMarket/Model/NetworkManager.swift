//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/16.
//

import Foundation

class NetworkManager {
    public static let publicNetworkManager = NetworkManager()
    
    static let identifier = "NetworkManager"
    static let itemDataNotification = "ItemDataNotification"
    
    func getItemListData(completion: @escaping (ItemList?) -> Void) {
        HTTPManager.requestGet(url: OpenMarketURL.base + OpenMarketURL.itemPage) { data in
            guard let data: ItemList = JSONConverter.decodeData(data: data) else {
                return
            }
            completion(data)
        }
    }
    
    func getItemData(completion: @escaping (Item?) -> Void) {
        HTTPManager.requestGet(url: OpenMarketURL.base + OpenMarketURL.product) { data in
            guard let data: Item = JSONConverter.decodeData(data: data) else {
                return
            }
            completion(data)
        }
    }
}
