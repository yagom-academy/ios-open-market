//
//  MockAPIManager.swift
//  OpenMarket
//
//  Created by Charlotte, Hosinging on 2021/08/10.
//

import Foundation

class MockAPIManager {
    static let shared = MockAPIManager()
    private init() {}
    
    func fetchProduct() {
        guard let url = URL(string: "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/3af41dec-56f1-47af-97c1-798c606386d0/Item.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210810%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210810T073851Z&X-Amz-Expires=86400&X-Amz-Signature=2e39b44e89edd3376615727e06532db5b423546aed5755017208f27754e25217&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Item.json%22") else { return }
        
   
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return
            }
            print(httpResponse.statusCode)
            if let data = data {
                print(String(data: data, encoding: .utf8))
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(ProductSearch.self, from: data)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
