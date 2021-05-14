//
//  ItemsSearcher.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/14.
//

import Foundation

final class ItemListSearcher: ItemListSearcherProtocol {
  func search(page: Int, completionHandler: @escaping (ListSearchResponse?) -> ()) {
    let url = "https://camp-open-market-2.herokuapp.com/items/\(page)"
    guard let requestURL: URL = URL(string: url) else { return }
    var request = URLRequest(url: requestURL)
    request.httpMethod = "GET"
    
    let urlSession = URLSession.shared
    
    urlSession.dataTask(with: request) { (data, response, error) in
      guard let responseStatus = response as? HTTPURLResponse, responseStatus.statusCode == 200 else {
        completionHandler(nil)
        print(OpenMarketError.invalidSearchResult)
        return
      }
      
      guard let data = data, error == nil else {
        completionHandler(nil)
        return
      }
      
      do {
        let urlResponse = try JSONDecoder().decode(ListSearchResponse.self, from: data)
        completionHandler(urlResponse)
      } catch {
        print(OpenMarketError.invalidSearchResult)
      }
    }.resume()
  }
}
