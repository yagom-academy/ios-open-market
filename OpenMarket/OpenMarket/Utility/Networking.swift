import Foundation

class Networking {
    private let baseURL = "https://camp-open-market.herokuapp.com/"
    private var request: URLRequest?
    //목록 조회
    //상품 등록
    //상품 조회
    //상품 수정
    //상품 삭제
    func fetchList(page: UInt) {
        guard let listURL = URL(string: "\(baseURL)items/\(page)") else {
            return
        }
        request = URLRequest(url: listURL)
        request?.httpMethod = "GET"
    }
    
    func registerItem(item: Item) {
        guard let itemURL = URL(string: "\(baseURL)item") else {
            return
        }
        request = URLRequest(url: itemURL)
        request?.httpMethod = "POST"
    }
    
    func fetchItem(id: UInt) {
        guard let itemURL = URL(string: "\(baseURL)item/\(id)") else {
            return
        }
        request = URLRequest(url: itemURL)
        request?.httpMethod = "GET"
    }
    
    func editItem(id: UInt) {
        guard let itemURL = URL(string: "\(baseURL)item/\(id)") else {
            return
        }
        request = URLRequest(url: itemURL)
        request?.httpMethod = "POST"
    }
    
    func removeItem(id: UInt) {
        guard let itemURL = URL(string: "\(baseURL)item/\(id)") else {
            return
        }
        request = URLRequest(url: itemURL)
        request?.httpMethod = "DELETE"
    }
    
    private func requestWithGetMethod(with request: URLRequest?, completion: (Result<Data, Error>) -> Void) {
        guard let request = request else {
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error != nil else {
                //Error Occurs
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                //Response Error
                return
            }
            
            guard let data = data else {
                //Data Error
                return
            }
            
            do {
                let json = try JSONDecoder().decode(Market.self, from: data)
                print(json)
            } catch let error {
                //Decoding Error
                print(error)
                return
            }
        }
    }
    
}
