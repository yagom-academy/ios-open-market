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
        cell.plusButton.isHidden = true
        cell.imageView.requestImageDownload(url: images[indexPath.row].url)
        return cell
    }
    
    func requestModifyProduct() {
        
        
    }
    
    @objc func doneToMain() {
        var data: String = ""
        guard let product = product else {
            return
        }
        data.append(compare(productView.nameField.text!, product.name, key: "name"))
        data.append(compare(productView.priceField.text!, String(product.price), key: "price"))
        data.append(compare(currency.rawValue, product.currency?.rawValue, key: "currency"))
        data.append(compare(productView.discountedPriceField.text!, String(product.discountedPrice), key: "discounted_price"))
        data.append(compare(productView.stockField.text!, String(product.stock), key: "stock"))
        data.append(compare(productView.descriptionView.text!, product.description, key: "descriptions"))
        
        if data.count > 0 {
            data.append("\"secret\": \"password\"")
            data.insert("{", at: data.startIndex)
            data.append("}")
            
            RequestAssistant.shared.requestModifyAPI(productId: product.id, body: data, identifier: "cd706a3e-66db-11ec-9626-796401f2341a") {_ in
                print("성공!")
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backToMain() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func compare(_ field: String?, _ original: String?, key: String) -> String {
        if field == original {
            return ""
        } else {
            return "\"\(key)\": \"\(field ?? "")\","
        }
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

        guard let userInfo = notification.userInfo else {
            return
        }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        productView.mainScrollView.setContentOffset(CGPoint(x: 0, y: keyboardFrame.size.height - 100), animated: true)
    }

    @objc func keyboardWillHide(notification: NSNotification) {

        guard let userInfo = notification.userInfo else {
            return
        }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        productView.mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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
}
