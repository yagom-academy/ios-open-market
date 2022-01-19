import Foundation

final class ListDataStorager: PageDataStorable {
    
    var storage: ProductListAsk.Response?
    let requester = ProductListAskRequester(pageNo: 1, itemsPerPage: 30)
    // TODO: init plus 
    static let cachedImages = NSCache<NSString,NSData>()

    func updateStorage(completion: @escaping () -> Void) {
        URLSession.shared.request(requester: requester) { (result) in
            switch result {
            case .success(let data):
                guard let data = self.requester.decode(data: data) else {
                    return
                }
                self.storage = data
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
