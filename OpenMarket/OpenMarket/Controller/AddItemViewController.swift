//
//  EmptyViewController.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/27.
//

import UIKit

final class AddItemViewController: UIViewController {
    let addItemView = AddItemView()
    var productImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationBar()
        configureLayout()
        configureImagePicker()
    }
    
    private func configureNavigationBar() {
        self.title = OpenMarketNaviItem.addItemTitle
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: OpenMarketNaviItem.cancel,
                                                                style: .plain,
                                                                target: self, action:
                                                                    #selector(tappedCancel(sender:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: OpenMarketNaviItem.done,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(tappedDone(sender:)))
    }
    
    @objc private func tappedCancel(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func tappedDone(sender: UIBarButtonItem) {
        guard let productNameText = addItemView.productNameTextField.text,
              productNameText.count >= 3 else {
                  showAlertController(title: OpenMarketAlert.productTextLimit,
                                      message: OpenMarketAlert.productTextLimitMessage)
                  return
              }
        
        guard addItemView.descTextView.text.count >= 1 && addItemView.descTextView.text.count <= 1000 else {
            showAlertController(title: OpenMarketAlert.descTextLimit,
                                message: OpenMarketAlert.descTextLimitMessage)
            return
        }
        
        guard let priceText = addItemView.priceTextField.text,
              !priceText.isEmpty else {
                  showAlertController(title: OpenMarketAlert.priceEmpty,
                                      message: OpenMarketAlert.priceEmptyMessage)
                  return
              }
        
        
        postItemDatas()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func postItemDatas() {
        guard let encodingData = JSONConverter.shared.encodeJson(param: receiveData()) else {
            return
        }
        
        HTTPManager.shared.requestPOST(url: OpenMarketURL.postProductComponent.url,
                                       encodingData: encodingData,
                                       images: productImages) { data in
        }
    }
    
    private func receiveData() -> Param? {
        guard let itemName = addItemView.productNameTextField.text,
              let itemDesc = addItemView.descTextView.text,
              let itemPrice = addItemView.priceTextField.text,
              let itemDiscountPrice = addItemView.priceForSaleTextField.text,
              let itemStock = addItemView.stockTextField.text else {
                  return nil
              }
        
        let itemCurrency = addItemView.currencySegmentControl.selectedSegmentIndex
        
        let param = Param(name: itemName,
                          description: itemDesc,
                          price: Int(itemPrice) ?? 0,
                          currency: itemCurrency == 0 ? .krw : .usd,
                          discountedPrice: Int(itemDiscountPrice) ?? 0,
                          stock: Int(itemStock) ?? 0,
                          secret: OpenMarketSecretCode.somPassword)
        
        return param
    }
}

extension AddItemViewController {
    func configureLayout() {
        self.view.addSubview(addItemView)
        
        addItemView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addItemView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            addItemView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            addItemView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            addItemView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension AddItemViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func configureImagePicker() {
        self.addItemView.registrationButton.addTarget(self,
                                                      action: #selector(showImagePicker),
                                                      for: .touchUpInside)
    }
    
    @objc func showImagePicker() {
        guard productImages.count <= 4 else {
            showAlertController(title: OpenMarketAlert.imageLimit,
                                message: OpenMarketAlert.imageLimitMessage)
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let lastIndex = productImages.count
        
        if let image = info[.editedImage] as? UIImage, productImages.isEmpty {
            self.addItemView.imageStackView.insertArrangedSubview(UIImageView(image: image), at: 0)
            self.productImages.append(image)
        } else if let image = info[.editedImage] as? UIImage, productImages.isEmpty == false {
            self.addItemView.imageStackView.insertArrangedSubview(UIImageView(image: image), at: lastIndex)
            self.productImages.append(image)
        }
        
        dismiss(animated: true)
    }
}

extension AddItemViewController {
    func showAlertController(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title,
                                                         message: message,
                                                         preferredStyle: .alert)
        
        let action: UIAlertAction = UIAlertAction(title: OpenMarketAlert.confirm,
                                                  style: .default,
                                                  handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
