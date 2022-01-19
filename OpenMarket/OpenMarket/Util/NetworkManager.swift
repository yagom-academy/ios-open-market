//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Eunsoo KIM on 2022/01/19.
//

import Foundation

struct NetworkManager {
  let session = URLSession(configuration: .default)
  
  func getItemList(pageNo: Int,
                   itmesPerPage: Int,
                   completion: @escaping (Result<ItemList, Error>) -> Void)
  {
    
    let url = URLMaker.itemListURL(pageNo: pageNo, itmesPerPage: itmesPerPage)

    let request = URLRequest(url: url)
    
    let dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
      guard error == nil else {
        guard let error = error else {
          return
        }
        completion(.failure(error))
        return
      }
      guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
      else {
        guard let error = error else {
          return
        }
        completion(.failure(error))
        return
      }
      guard let recievedData = data else {
        return
      }
      
      guard let result = try? JSONDecoder().decode(ItemList.self, from: recievedData) else {
        return
      }
      completion(.success(result))
      
    }
    dataTask.resume()
    
  }
  
  func getItemInfo(itemId: Int,
                   completion: @escaping (Result<Item, Error>) -> Void)
  {
    
    let url = URLMaker.itemInfoURL(itemId: itemId)
    print(url)
    let request = URLRequest(url: url)
    
    let dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
      guard error == nil else {
        guard let error = error else {
          return
        }
        completion(.failure(error))
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
      else {
        guard let error = error else {
          return
        }
        completion(.failure(error))
        return
      }
      
      guard let recievedData = data else {
        return
      }
      
      guard let result = try? JSONDecoder().decode(Item.self, from: recievedData) else {
        return
      }
      completion(.success(result))
      
    }
    dataTask.resume()
  }
  
  
}
