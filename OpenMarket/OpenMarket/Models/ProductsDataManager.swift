import Foundation

struct ProductsDataManager {
    func getData(pageNumber: Int, itemsPerPage: Int, completion: @escaping (Result<Products, Error>) -> Void) {
        
        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)") else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let decodingContext = DecodingError.Context.init(codingPath: Products.CodingKeys.allCases, debugDescription: "")
                completion(.failure(DecodingError.dataCorrupted(decodingContext)))
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode(Products.self, from: data) else {
                let decodingContext = DecodingError.Context.init(codingPath: Products.CodingKeys.allCases, debugDescription: "")
                completion(.failure(DecodingError.typeMismatch(Products.self, decodingContext)))
                return
            }
            
            completion(.success(decodedData))
        }
        task.resume()
    }
    
    func getData(productId: Int, completion: @escaping (Result<Page, Error>) -> ()) {
        
        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products/\(productId)") else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let decodingContext = DecodingError.Context.init(codingPath: Page.CodingKeys.allCases, debugDescription: "")
                completion(.failure(DecodingError.dataCorrupted(decodingContext)))
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode(Page.self, from: data) else {
                let decodingContext = DecodingError.Context.init(codingPath: Page.CodingKeys.allCases, debugDescription: "")
                completion(.failure(DecodingError.typeMismatch(Page.self, decodingContext)))
                return
            }
            
            completion(.success(decodedData))
        }
        task.resume()
    }
}
