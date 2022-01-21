//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Eunsoo KIM on 2022/01/19.
//

import Foundation

struct NetworkManager {
  private let session = URLSession(configuration: .default)
  
  func getItemList(pageNo: Int,
                   itemsPerPage: Int,
                   completion: @escaping (Result<ItemList, Error>) -> Void)
  {
    guard let url = URLMaker.itemListURL(pageNo: pageNo, itemsPerPage: itemsPerPage) else {
      return
    }
    
    var request = URLRequest(url: url, httpMethod: .get)
    request.timeoutInterval = 3
    
    let dataTask = session.dataTask(request: request) { result in
      switch result {
      case .success(let data):
        guard let result = try? JSONDecoder().decode(ItemList.self, from: data) else {
          return
        }
        completion(.success(result))
      case .failure(let error):
        completion(.failure(error))
      }
    }
    
    dataTask.resume()
  }
  
  func getItemInfo(itemId: Int,
                   completion: @escaping (Result<Item, Error>) -> Void)
  {
    let url = URLMaker.itemInfoURL(itemId: itemId)
    let request = URLRequest(url: url, httpMethod: .get)
    
    let dataTask = session.dataTask(request: request) { result in
      switch result {
      case .success(let data):
        guard let result = try? JSONDecoder().decode(Item.self, from: data) else {
          return
        }
        completion(.success(result))
      case .failure(let error):
        completion(.failure(error))
      }
    }
    
    dataTask.resume()
  }
}
