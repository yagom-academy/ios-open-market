import Foundation

final class ListDataStorager: DataStorable {
    
    var storage: Decodable?
    let requester = ProductListAskRequester(pageNo: 1, itemsPerPage: 30)
    // TODO: init plus 
    static let cacheImage = NSCache<NSString,NSData>()
    
    func updateStorage() {
        URLSession.shared.request(requester: requester) { (result) in
            switch result {
            case .success(let data):
                guard let data = self.requester.decode(data: data) else {
                    return
                }
                self.storage = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
