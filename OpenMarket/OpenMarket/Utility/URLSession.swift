//
//  URLSession.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/12.
//

import Foundation

func dataTask() {
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    var urlComponents = URLComponents(string: URLData.host.rawValue + URLData.lookUpProductList.rawValue)
    let pageNo = URLQueryItem(name: "page_no", value: "1")
    let itemsPerPage = URLQueryItem(name: "items_per_page", value: "10")
    urlComponents?.queryItems?.append(pageNo)
    urlComponents?.queryItems?.append(itemsPerPage)
    guard let requestURL = urlComponents?.url else {
        return
    }
    let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
        guard error == nil else {
            return
        }
        let successsRange = 200..<300
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
              successsRange.contains(statusCode) else {
            return
        }
        guard let resultData = data,
              let fetchedData = decode(from: resultData, to: ProductPage.self) else {
            debugPrint("ERROR: FAILURE DECODING ")
            return
        }
        fetchedData.printPage()
    }
    dataTask.resume()
}
