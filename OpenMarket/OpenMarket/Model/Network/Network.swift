//
//  Network.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/20.
//

import UIKit

protocol MainViewDelegate: UIViewController {
    func setSnapshot(productInformations: [ProductInformation])
    func showErrorAlert(error: Error)
}

final class Network: NetworkAble {
    
    static let shared = Network()
    
    private let decoder = JSONDecoder()
    //weak var delegate: MainViewDelegate?
    let session: URLSessionProtocol
    
    private init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func setImageFromUrl(imageUrl: URL, imageView: UIImageView) -> URLSessionDataTask? {
        guard let dataTask = requestData(url: imageUrl, completeHandler: {
            data, error in
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }, errorHandler: {
            error in
        }) else {
            return nil
        }
        return dataTask
    }
    
    func setImageFromUrl(imageUrl imageUrlString: String, imageView: UIImageView) -> URLSessionDataTask? {
        guard let url = URL(string: imageUrlString) else {
            return nil
        }
        return setImageFromUrl(imageUrl: url, imageView: imageView)
    }
    
    func requestDecodedData(pageNo: Int, itemsPerPage: Int, delegate: MainViewDelegate?) {
        guard let url = OpenMarketApi.pageInformation(pageNo: pageNo, itemsPerPage: itemsPerPage).url else {
            DispatchQueue.main.async {
                delegate?.showErrorAlert(error: NetworkError.urlError)
            }
            return
        }
        
        requestData(url: url) { data, urlResponse in
            guard let data = data,
                  let pageInformation = try? JSONDecoder().decode(PageInformation.self, from: data) else { return }
            DispatchQueue.main.async {
                delegate?.setSnapshot(productInformations: pageInformation.pages)
            }
        } errorHandler: { error in
            DispatchQueue.main.async {
                delegate?.showErrorAlert(error: error)
            }
        }
    }
}
