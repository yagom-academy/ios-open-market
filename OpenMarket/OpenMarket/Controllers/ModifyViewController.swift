//
//  ModifyViewController.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/12/03.
//

import UIKit

final class ModifyViewController: ProductViewController {
    private let maxImageNumber = 5
    private var modifyProductView = ModifyProductView()
    private var productData: Product?
    
    override var showView: ProductView {
        return modifyProductView
    }
    
    init(data: Product?, images: [UIImage?]) {
        super.init(nibName: nil, bundle: nil)
        productData = data
        self.cellImages = images
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: "상품수정")
        self.view = showView
        showView.collectionView.delegate = self
        showView.collectionView.dataSource = self
        bindingData(productData)
        print(cellImages.count)
    }
    
    override func setupData() -> Result<NewProduct, DataError> {
        guard let name = showView.nameTextField.text,
              let description = showView.descriptionTextView.text,
              let priceString = showView.priceTextField.text,
              let price = Double(priceString) else { return Result.failure(.none) }
        
        var newProduct = NewProduct(name: name, productID: productData?.id,
                                    description: description,
                                    currency: showView.currency,
                                    price: price)
        
        if showView.salePriceTextField.text != nil {
            guard let salePriceString = showView.salePriceTextField.text else { return Result.failure(.none) }
            newProduct.discountedPrice = Double(salePriceString)
        }
        if showView.stockTextField.text != nil {
            guard let stock = showView.stockTextField.text else { return Result.failure(.none) }
            newProduct.stock = Int(stock)
        }
        
        return Result.success(newProduct)
    }
}

// MARK: - Override doneButtonTapped
extension ModifyViewController {
    override func doneButtonTapped() {
        guard let productData = productData else { return }
        let result = setupData()
        switch result {
        case .success(let data):
            guard let patchURL = NetworkRequest.patchData(productID: productData.id).requestURL else { return }
            networkManager.patchData(url: patchURL, updateData: data) { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.showAlert(alertText: Constant.uploadSuccessText.rawValue,
                                       alertMessage: Constant.uploadSuccessMessage.rawValue) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(alertText: error.description,
                                       alertMessage: Constant.failureMessage.rawValue,
                                       completion: nil)
                    }
                }
            }
        case .failure(let error):
            self.showAlert(alertText: error.description,
                           alertMessage: Constant.confirmMessage.rawValue,
                           completion: nil)
        }
    }
}

// MARK: - Binding Data in View
extension ModifyViewController {
    private func bindingData(_ data: Product?) {
        guard let data = data else { return }
        modifyProductView.bindProductData(product: data)
    }
}

// MARK: - Extension UICollectionView
extension ModifyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellImages.count < maxImageNumber ? cellImages.count + 1 : maxImageNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier,
            for: indexPath) as? ImageCollectionViewCell
        else {
            self.showAlert(alertText: NetworkError.data.description,
                           alertMessage: "오류가 발생했습니다.",
                           completion: nil)
            let errorCell = UICollectionViewCell()
            return errorCell
        }
        
        if indexPath.item != cellImages.count {
            let view = cell.createImageView()
            view.image = cellImages[indexPath.item]
            cell.stackView.addArrangedSubview(view)
        }

        return cell
    }
}
