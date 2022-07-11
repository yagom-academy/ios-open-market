import Foundation

struct ProductsDataManager {
    func getData(pageNumber: Int, itemsPerPage: Int, completion: @escaping (Products) -> ()) {
        
        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)") else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            let decodedData = try! JSONDecoder().decode(Products.self, from: data!)
            
            completion(decodedData)
        }
        task.resume()
    }
    
    func getData(productId: Int, completion: @escaping (Page) -> ()) {
        
        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products/\(productId)") else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            let decodedData = try! JSONDecoder().decode(Page.self, from: data!)
            
            completion(decodedData)
        }
        task.resume()
    }
}
