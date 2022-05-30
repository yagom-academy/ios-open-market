//
//  ReviseViewController.swift
//  OpenMarket
//
//  Created by song on 2022/05/29.
//

import UIKit

final class CorrectionViewController: ProductManagementViewController {
    private let product: Product

    override func viewDidLoad() {
        super.viewDidLoad()
        view = baseView
        productManagementType = ManagementType.correction
        setupNavigationItems()
        getDetailData()
    }
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getDetailData() {
        guard let id = product.id else {
            return
        }

        network.fetchData(from: .detailProduct(id: id)) { result in
            switch result {
            case .success(let product):
                self.setupView(product: product)
            case .failure(let error):
                self.showAlert(title: "Error", message: error.errorDescription)
            }
        }
    }
    
    private func setupView(product: Product) {
        DispatchQueue.main.async { [self] in
            baseView.productName.text = product.name
            baseView.productPrice.text = product.price?.description
            baseView.currencySegmentControl.selectedSegmentIndex = 0
            baseView.productDiscountedPrice.text = product.discountedPrice?.description
            baseView.productStock.text = product.stock?.description
            baseView.productDescription.text = product.description
            
            product.images?.forEach { image in
                let imageView = convertImageView(from: image.url) ?? UIImageView()
                self.baseView.imagesStackView.addArrangedSubview(imageView)
            }
        }
    }
    
    private func convertImageView(from urlString: String?) -> UIImageView? {
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
    
    private func patchData() {
        guard let id = product.id else {
            return
        }
        
        let productRegistration = extractData()

        network.patchData(product: productRegistration, id: id) { result in
            if case .failure(let error) = result {
                self.showAlert(title: "Error", message: error.errorDescription)
            }
        }
    }
}

// MARK: - navigationBar

extension CorrectionViewController {
    private func setupNavigationItems() {
        self.navigationItem.title = productManagementType?.type
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDoneButton))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapDoneButton() {
        self.showAlert(title: "Really", ok: "ok", cancel: "cancel", action: patchData)
    }
}
