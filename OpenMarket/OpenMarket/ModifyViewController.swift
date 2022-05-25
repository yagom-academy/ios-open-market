//
//  ModifyViewController.swift
//  OpenMarket
//
//  Created by 김태훈 on 2022/05/24.
//

import UIKit

class ModifyViewController: UIViewController {
    var product: Product?
    lazy var productView = ProductView(frame: view.frame)
    var currency: Currency = .KRW
    weak var delegate: ListUpdatable?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = productView
        self.view.backgroundColor = .white
        
        self.navigationItem.title = "상품수정"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneToMain))
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.hidesBackButton = true
        let backbutton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backToMain))
        backbutton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.preferredFont(for: .body, weight: .semibold)], for: .normal)
        self.navigationItem.leftBarButtonItem = backbutton
        
        productView.collectionView.delegate = self
        productView.collectionView.dataSource = self
        
        
        productView.currencyField.addTarget(self, action: #selector(changeCurrency(_:)), for: .valueChanged)
        fillData()
    }
    
    func fillData() {
        guard let product = product else {
            return
        }
        
        productView.currencyField.selectedSegmentIndex = product.currency!.value
        self.changeCurrency(productView.currencyField)
        
        productView.nameField.text = product.name
        productView.priceField.text = String(product.price)
        productView.stockField.text = String(product.stock)
        productView.descriptionView.text = product.description
        productView.discountedPriceField.text = String(product.discountedPrice)
    }
    
    @objc func changeCurrency(_ sender: UISegmentedControl) {
        let mode = sender.selectedSegmentIndex
        if mode == Currency.KRW.value {
            currency = Currency.KRW
        } else if mode == Currency.USD.value {
            currency = Currency.USD
        }
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
    
    func requestModifyProduct() {
        
        
    }
    
    @objc func doneToMain() {
        guard let product = product else {
            return
        }
        var data = makeModifyRequestBody(for: product)
        if data.count > 0 {
            data.append("\"secret\": \"password\"")
            data.insert("{", at: data.startIndex)
            data.append("}")
            
            RequestAssistant.shared.requestModifyAPI(productId: product.id, body: data, identifier: "cd706a3e-66db-11ec-9626-796401f2341a") { [self]_ in
                delegate?.refreshProductList()
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backToMain() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func makeModifyRequestBody(for product: Product) -> String {
        var data: String = ""
        guard productView.validTextField(productView.nameField) else {
            let alert = UIAlertController(title: "상품명을 3자 이상 100자 이하로 입력해주세요.", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "취소", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
            return data
        }
        guard productView.validTextView(productView.descriptionView) else {
            let alert = UIAlertController(title: "상품 설명을 10자 이상 1000자 이하로 입력해주세요.", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "취소", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
            return data
        }
        data.append(compare(productView.nameField.text, product.name, key: "name"))
        data.append(compare(Double(productView.priceField.text!),product.price, key: "price"))
        data.append(compare(currency.rawValue, product.currency?.rawValue, key: "currency"))
        data.append(compare(Double(productView.discountedPriceField.text!), product.discountedPrice, key: "discounted_price"))
        data.append(compare(Int(productView.stockField.text!), product.stock, key: "stock"))
        if let description: String = self.productView.descriptionView.text {
            data.append(compare(description, product.description!, key: "descriptions"))
        }
        return data
    }
    
    func compare<T: Equatable>(_ field: T?, _ original: T, key: String) -> String {
        guard let field1 = field else {
            return ""
        }
        
        if field == original {
            return ""
        } else if type(of: original) == String.self {
            return "\"\(key)\": \"\(field1)\","
        } else {
            return "\"\(key)\": \(field1),"
        }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        productView.endEditing(true)
    }
}
