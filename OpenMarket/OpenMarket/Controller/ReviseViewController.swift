//
//  ReviseViewController.swift
//  OpenMarket
//
//  Created by song on 2022/05/29.
//

import UIKit

final class ReviseViewController: UIViewController {
    private let product: Product
    private lazy var baseView = ProductRegistrationView(frame: view.frame)
    private let network = URLSessionProvider<Product>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = baseView
        setupNavigationItems()
        getData()
    }
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(product: Product) {
        baseView.productName.text = product.name
        baseView.productPrice.text = product.price?.description
        baseView.currencySegmentControl.selectedSegmentIndex = 0
        baseView.productBargenPrice.text = product.bargainPrice?.description
        baseView.productStock.text = product.stock?.description
        baseView.productDescription.text = product.description
        
        product.images?.forEach { image in
            let imageView = convertImageView(from: image.url) ?? UIImageView()
            self.baseView.imagesStackView.addArrangedSubview(imageView)
        }
    }
    
    private func getData() {
        network.fetchData(from: .detailProduct(id: product.id!)) { result in
            switch result {
            case .success(let product):
                DispatchQueue.main.async {
                    self.setupView(product: product)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupNavigationItems() {
        self.navigationItem.title = "상품수정"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDoneButton))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapDoneButton() {
        self.showAlert(title: "Really?", ok: "Yes", cancel: "No")
    }
}

extension ReviseViewController {
    func convertImageView(from urlString: String?) -> UIImageView? {
        guard let imageString = urlString else {
            return nil
        }
        
        guard let url = URL(string: imageString) else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        guard let image = UIImage(data: data) else {
            return nil
        }
        
        let imageView = UIImageView(image: image)
        
        return imageView
    }
}
