//////
//////  APIManager.swift
//////  OpenMarket
//////
//////  Created by Sunny, James on 2021/05/17.
//////
////
//import Foundation
//
//class OpenMarketAPIProvider {
//    let urlSession: URLSession
//
//    init(urlSession: URLSession = .shared) {
//        self.urlSession = urlSession
//    }
//
//    func fetchItemListData(completion: @escaping(_ result: Result <MarketItemList, Error>) -> Void) {
//        guard let url = URL(string: "https://camp-open-market-2.herokuapp.com/Items/2") else { return }
//        let dataTask = urlSession.dataTask(with: url) { data, response, error in
//            do {
//                if let error = error {
//                    completion(Result.failure(error))
//                    return
//                }
//
//                guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
//                    completion(Result.failure(APIError.invalidApproach))
//                    return
//                }
//
//                if let data = data,
//                   let object = try? JSONDecoder().decode(MarketItemList.self, from: data)  {
//                    completion(Result.success(object))
//                } else {
//                    throw APIError.invalidApproach
//                }
//            } catch {
//                completion(Result.failure(error))
//            }
//        }
//        dataTask.resume()
//    }
//
//}
