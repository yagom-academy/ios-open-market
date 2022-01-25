import Foundation
import UIKit

class PostManager {
    
    var delegate: PostManagerDelegate?
    var postParams: ProductPost.Request.Params?
    var postImages: [UIImage]?
    
    func loadComponents(images: [UIImage], params: ProductPost.Request.Params) {
        postImages = images
        postParams = params
    }
    
    func makeMultiPartFormData() {
        guard let postImages = postImages else {
            return
        }
        
        guard let postParams = postParams else {
            return
        }
        
        var requester = ProductPostRequester(params: postParams, images: postImages)
        let body = requester.createBody(productRegisterInformation: postParams, images: postImages, boundary: requester.boundary ?? "")
        requester.httpBody = body
        
        URLSession.shared.request(requester: requester) { result in
            switch result {
            case .success(let data):
            //TODO: - storage를 업데이트 시켜주고 Page화면에 Alert
                print("성공")
            case .failure(let error):
            //TODO: - Register화면에 통신이 실패했다고 Alert
                print("실패")
            }
        }
    }
}

protocol PostManagerDelegate {

}
