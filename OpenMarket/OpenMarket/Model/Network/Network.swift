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
    
    private let decoder = JSONDecoder()
    weak var delegate: MainViewDelegate?
    let session: URLSessionProtocol
    
    init(delegate: MainViewDelegate, session: URLSessionProtocol = URLSession.shared) {
        self.session = session
        self.delegate = delegate
    }
    
    func requestDecodedData(pageNo: Int, itemsPerPage: Int) {
        guard let url = OpenMarketApi.pageInformation(pageNo: pageNo, itemsPerPage: itemsPerPage).url else {
            DispatchQueue.main.async {
                self.delegate?.showErrorAlert(error: NetworkError.urlError)
            }
            return
        }
        
        requestData(url: url) { data, urlResponse in
            guard let data = data,
                  let pageInformation = try? JSONDecoder().decode(PageInformation.self, from: data) else { return }
            DispatchQueue.main.async {
                self.delegate?.setSnapshot(productInformations: pageInformation.pages)
            }
        } errorHandler: { error in
            DispatchQueue.main.async {
                self.delegate?.showErrorAlert(error: error)
            }
        }
    }
}
