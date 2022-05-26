//
//  ModifyViewController.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/24.
//

import UIKit

class ModifyViewController: UIViewController {
    var product: Product?
    lazy var productView = ProductView(frame: view.frame)
    private var currency: Currency = .KRW
    weak var delegate: ListUpdatable?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = productView
        self.view.backgroundColor = .white
        
        defineCollectionViewDelegate()
        defineTextFieldDelegate()
        setUpProductViewContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.productView.mainScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            
            if self.productView.descriptionView.isFirstResponder {
                productView.mainScrollView.scrollRectToVisible(productView.descriptionView.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.productView.mainScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    private func setUpNavigationBar() {
        self.navigationItem.title = "상품수정"
        let requestButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(requestModification))
        self.navigationItem.rightBarButtonItem = requestButton
        self.navigationItem.hidesBackButton = true
        let cancelbutton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelModification))
        cancelbutton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.preferredFont(for: .body, weight: .semibold)], for: .normal)
        self.navigationItem.leftBarButtonItem = cancelbutton
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
    
    @objc private func cancelModification() {
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
        productView.currencyField.addTarget(self, action: #selector(changeCurrency(_:)), for: .valueChanged)
        productView.currencyField.selectedSegmentIndex = value
        self.changeCurrency(productView.currencyField)
    }
    
    @objc func changeCurrency(_ sender: UISegmentedControl) {
        let mode = sender.selectedSegmentIndex
        if mode == Currency.KRW.value {
            currency = Currency.KRW
        } else if mode == Currency.USD.value {
            currency = Currency.USD
        }
    }
    
    private func makeRequestBody() -> Data? {
        guard productView.validTextField(productView.nameField) else {
            let alert = UIAlertController(title: "상품명을 3자 이상 100자 이하로 입력해주세요.", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "취소", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
            return nil
        }
        guard productView.validTextView(productView.descriptionView) else {
            let alert = UIAlertController(title: "상품 설명을 10자 이상 1000자 이하로 입력해주세요.", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "취소", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
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
              let price: Double = Double(productView.priceField.text ?? "0.0"),
              let discountedPrice: Double = Double(productView.discountedPriceField.text ?? "0.0"),
              let stock: Int = Int(productView.stockField.text ?? "0")
              else {
            return modifyProduct
        }
        
        name != product.name ? modifyProduct.name = name : nil
        description != product.description ? modifyProduct.descriptions = description : nil
        price != product.price ? modifyProduct.price = price : nil
        discountedPrice != product.discountedPrice ? modifyProduct.discountedPrice = discountedPrice : nil
        stock != product.stock ? modifyProduct.stock = stock : nil
        currency != product.currency ? modifyProduct.currency = currency : nil
        
        return modifyProduct
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





// MARK: - Common
extension ModifyViewController {
    
}

extension ModifyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.keyboardType == .numberPad {
            if CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) {
                return true
            }
        }
        return false
    }
}

extension ModifyViewController {
    private func defineCollectionViewDelegate() {
        productView.collectionView.delegate = self
        productView.collectionView.dataSource = self
    }
    
    private func defineTextFieldDelegate() {
        productView.priceField.delegate = self
        productView.discountedPriceField.delegate = self
        productView.stockField.delegate = self
    }
}
