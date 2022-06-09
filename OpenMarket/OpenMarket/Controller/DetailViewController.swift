//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/31.
//

import UIKit

final class DetailViewController: UIViewController, ActivityIndicatorProtocol {
    
    private let productNumber: Int
    
    init(producntNubmer: Int) {
        self.productNumber = producntNubmer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let productDetailUseCase = ProductDetailUseCase(
        network: Network(),
        jsonDecoder: JSONDecoder()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        generateDetailView(id: productNumber)
        configureIndicator()
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.red
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    private func generateDetailView(id: Int?) {
        guard let id = id else { return }
        let detailView = DetailView(frame: self.view.bounds)
        productDetailUseCase.requestProductDetailInformation(
            id: id) { detailInformation in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    detailView.setUpView(productDetail: detailInformation)
                    self.activityIndicator.stopAnimating()
                    self.view.addSubview(detailView)
                }
            } errorHandler: { error in
                print(error)
            }
    }
}
