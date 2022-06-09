//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/31.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let productNumber: Int
    
    init(producntNubmer: Int) {
        self.productNumber = producntNubmer
        super.init()
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
        generateDetailView(id: productNumber)
    }
    
    private func generateDetailView(id: Int?) {
        guard let id = id else { return }
        let detailView = DetailView.init(frame: self.view.bounds)
        productDetailUseCase.requestProductDetailInformation(
            id: id) { detailInformation in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    detailView.setUpView(productDetail: detailInformation)
                    self.view.addSubview(detailView)
                }
            } errorHandler: { error in
                print(error)
            }
    }
}
