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
                print("성공")
            case .failure(let error):
                print("실패")
            }
        }
    }
}

protocol PostManagerDelegate {
//    var images: [UIImage] { get set }
    //서로 소통하는 메서드들이 있다
}
