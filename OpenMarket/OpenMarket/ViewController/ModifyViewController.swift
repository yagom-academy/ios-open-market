//
//  ModifyViewController.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/24.
//

import UIKit

final class ModifyViewController: ProductViewController {
    var product: Product?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        defineCollectionViewDelegate()
        setUpProductViewContent()
    }
    
    override func setUpNavigationBar() {
        super.setUpNavigationBar()
        self.navigationItem.title = "상품수정"
        let requestButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(requestModification))
        self.navigationItem.rightBarButtonItem = requestButton
    }
    
    @objc private func requestModification() {
        guard let product = product else {
            return
        }
        guard let data = makeRequestBody() else {
            return
        }
        
        RequestAssistant.shared.requestModifyAPI(productId: product.id, body: data) { [self]_ in
            delegate?.refreshProductList()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setUpProductViewContent() {
        guard let product = product else {
            return
        }
        guard let currency = product.currency else {
            return
        }
        setUpInitialCurrencyState(currency.value)
        
        productView.nameField.text = product.name
        productView.priceField.text = String(product.price)
        productView.stockField.text = String(product.stock)
        productView.descriptionView.text = product.description
        productView.discountedPriceField.text = String(product.discountedPrice)
    }
    
    private func setUpInitialCurrencyState(_ value: Int) {
        productView.currencyField.selectedSegmentIndex = value
        self.changeCurrency(productView.currencyField)
    }
    
    private func makeRequestBody() -> Data? {
        guard productView.validTextField(productView.nameField) else {
            showAlert(alertTitle: "상품명을 3자 이상 100자 이하로 입력해주세요.")
            return nil
        }
        guard productView.validTextView(productView.descriptionView) else {
            showAlert(alertTitle: "상품 설명을 10자 이상 1000자 이하로 입력해주세요.")
            return nil
        }
        guard let data = try? JSONEncoder().encode(detectModifiedContent()) else {
            return nil
        }
        
        return data
    }
    
    private func detectModifiedContent() -> ProductToModify {
        var modifyProduct: ProductToModify = ProductToModify()
        guard let product = product else {
            return modifyProduct
        }
        
        guard let name: String = productView.nameField.text,
              let description: String = self.productView.descriptionView.text,
              let price: Double = Double(productView.priceField.text ?? "0.0")
        else {
            return modifyProduct
        }
        let discountedPrice: Double = Double(productView.discountedPriceField.text ?? "0.0") ?? 0.0
        let stock: Int = Int(productView.stockField.text ?? "0") ?? 0
        
        name != product.name ? modifyProduct.name = name : nil
        description != product.description ? modifyProduct.descriptions = description : nil
        price != product.price ? modifyProduct.price = price : nil
        discountedPrice != product.discountedPrice ? modifyProduct.discountedPrice = discountedPrice : nil
        stock != product.stock ? modifyProduct.stock = stock : nil
        currency != product.currency ? modifyProduct.currency = currency : nil
        
        return modifyProduct
    }
    
    private func defineCollectionViewDelegate() {
        productView.collectionView.delegate = self
        productView.collectionView.dataSource = self
    }
}

extension ModifyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.4, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let images = product?.images else {
            return .zero
        }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageRegisterCell else {
            return ImageRegisterCell()
        }
        guard let images = product?.images else {
            return ImageRegisterCell()
        }
        cell.imageView.backgroundColor = .clear
        cell.plusButton.isHidden = true
        cell.imageView.requestImageDownload(url: images[indexPath.row].url)
        return cell
    }
}
