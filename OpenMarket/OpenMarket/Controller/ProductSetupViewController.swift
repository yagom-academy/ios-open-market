//
//  ProductSetupViewController.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/28.
//

import UIKit

final class ProductSetupViewController: UIViewController {
    // MARK: - Properties
    private var productSetupView: ProductSetupView?
    private var imagePicker = UIImagePickerController()
    var productId: Int?
    var viewControllerTitle: String?
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        productSetupView = ProductSetupView(self)
        setupNavigationItem()
        setupKeyboard()
        setupPickerViewController()
        adoptTextFieldDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let productId = productId else {
            productSetupView?.horizontalStackView.addArrangedSubview(productSetupView?.addImageButton ?? UIButton())
            return
        }
        NetworkManager.shared.requestProductDetail(at: productId) { detail in
            DispatchQueue.main.async { [weak self] in
                self?.updateSetup(with: detail)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // MARK: - @objc method
    @objc private func keyboardWillAppear(_ sender: Notification) {
        guard let userInfo = sender.userInfo, let keyboarFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboarFrame.size.height, right: 0.0)
        productSetupView?.mainScrollView.contentInset = contentInset
        productSetupView?.mainScrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillDisappear(_ sender: Notification) {
        let contentInset = UIEdgeInsets.zero
        productSetupView?.mainScrollView.contentInset = contentInset
        productSetupView?.mainScrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @objc private func cancelButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func doneButtonDidTapped() {
        if let _ = productId {
            productUpdate()
        } else {
            productRegist()
        }
    }
    
    @objc private func pickImage() {
        if productSetupView?.horizontalStackView.subviews.count == 6 {
            showAlert(title: "추가할 수 없습니다", message: "5장 이상은 추가 할 수 없습니다.")
            return
        }
        self.present(imagePicker, animated: true)
    }
    
    @objc private func changeCurrencyKeyboard() {
        view.endEditing(true)
        if productSetupView?.currencySegmentControl.selectedSegmentIndex == 0 {
            productSetupView?.productPriceTextField.keyboardType = .numberPad
            productSetupView?.productDiscountedPriceTextField.keyboardType = .numberPad
        } else {
            productSetupView?.productPriceTextField.keyboardType = .decimalPad
            productSetupView?.productDiscountedPriceTextField.keyboardType = .decimalPad
        }
    }
    // MARK: - ProductSetupVC - Private method
    private func createProductRegistration() -> ProductRegistration? {
        guard let productSetupView = productSetupView,
              let productName = productSetupView.productNameTextField.text,
              let price = Double(productSetupView.productPriceTextField.text ?? ""),
              let discountedPrice = Double(productSetupView.productDiscountedPriceTextField.text ?? ""),
              let stock = Int(productSetupView.productStockTextField.text ?? "")
        else {
            showAlert(title: "알림", message: "텍스트필드에 제대로 된 값을 넣어주세요")
            return nil
        }
        guard let descriptions = productSetupView.descriptionTextView.text != "" ? productSetupView.descriptionTextView.text : " " else {
            return nil
        }
        let currency = productSetupView.currencySegmentControl.selectedSegmentIndex == 0 ? Currency.krw : Currency.usd
        let productRegistration = ProductRegistration(name: productName,
                                                      descriptions: descriptions,
                                                      price: price,
                                                      currency: currency,
                                                      discountedPrice: discountedPrice,
                                                      stock: stock,
                                                      secret: URLData.secret
        )
        return productRegistration
    }
    
    private func createProductModification() -> ModificationData? {
        guard let productSetupView = productSetupView,
              let productId = self.productId,
              let productName = productSetupView.productNameTextField.text,
              let price = Double(productSetupView.productPriceTextField.text ?? ""),
              let discountedPrice = Double(productSetupView.productDiscountedPriceTextField.text ?? ""),
              let stock = Int(productSetupView.productStockTextField.text ?? "")
        else {
            showAlert(title: "알림", message: "텍스트필드에 값을 넣어주세요")
            return nil
        }
        guard let descriptions = productSetupView.descriptionTextView.text != "" ? productSetupView.descriptionTextView.text : " " else {
            return nil
        }
        let currency = productSetupView.currencySegmentControl.selectedSegmentIndex == 0 ? Currency.krw : Currency.usd
        let modification = ModificationData(id: productId,
                                            name: productName,
                                            descriptions: descriptions,
                                            price: price,
                                            currency: currency,
                                            discountedPrice: discountedPrice,
                                            stock: stock
        )
        return modification
    }
    
    private func productRegist() {
        guard let productRegistration = createProductRegistration(),
              let images = createImages()
        else {
            return
        }
        NetworkManager.shared.requestProductRegistration(with: productRegistration, images: images) { detail in
            DispatchQueue.main.async {
                self.showAlert(title: "알림", message: "게시 완료!!") {
                    self.navigationController?.popViewController(animated: true)
                    NotificationCenter.default.post(name: .refresh, object: nil)
                }
            }
        }
    }
    
    private func productUpdate() {
        guard let id = self.productId,
              let modificationData = createProductModification() else {
            return
        }
        let rowData = NetworkManager.shared.translateToRowData(modificationData)
        
        NetworkManager.shared.requestProductModification(id: id, rowData: rowData) { detail in
            DispatchQueue.main.async {
                self.showAlert(title: "알림", message: "수정 완료!!") {
                    self.navigationController?.popViewController(animated: true)
                    NotificationCenter.default.post(name: .refresh, object: nil)
                }
            }
        }
    }
    
    private func createImages() -> [UIImage]? {
        guard let productSetupView = productSetupView else {
            return nil
        }
        var subviews = productSetupView.horizontalStackView.subviews
        subviews.removeFirst()
        if subviews.count == 0 {
            showAlert(title: "알림", message: "최소 한장의 이미지를 추가 해주세요.")
            return nil
        }
        let images = subviews.map { (subview) -> UIImage in
            let uiimage = subview as? UIImageView
            return uiimage?.image ?? UIImage()
        }
        return images
    }
    
    private func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidTapped))
        navigationItem.title = self.viewControllerTitle
    }
    
    private func setupKeyboard() {
        productSetupView?.confirmButton.addTarget(self, action: #selector(hideKeyboard(_:)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification , object: nil)
        productSetupView?.currencySegmentControl.addTarget(self, action: #selector(changeCurrencyKeyboard), for: .valueChanged)
    }
    
    private func setupPickerViewController() {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        productSetupView?.addImageButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
    }
    
    private func adoptTextFieldDelegate() {
        productSetupView?.productNameTextField.delegate = self
        productSetupView?.productPriceTextField.delegate = self
        productSetupView?.productStockTextField.delegate = self
        productSetupView?.productDiscountedPriceTextField.delegate = self
    }
    
    private func updateSetup(with detail: ProductDetail) {
        detail.images.forEach { image in
            let imageView = PickerImageView(frame: CGRect())
            imageView.setImageUrl(image.url)
            productSetupView?.horizontalStackView.addArrangedSubview(imageView)
        }
        productSetupView?.productNameTextField.text = detail.name
        productSetupView?.productPriceTextField.text = String(detail.price)
        productSetupView?.productDiscountedPriceTextField.text = String(detail.discountedPrice)
        productSetupView?.productStockTextField.text = String(detail.stock)
        productSetupView?.descriptionTextView.text = detail.description
        productSetupView?.currencySegmentControl.selectedSegmentIndex = detail.currency == Currency.krw.rawValue ? 0 : 1
    }
    
    private func showAlert(title: String, message: String, _ completion: (() -> Void)? = nil) {
        let failureAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            guard let completion = completion else { return }
            completion()
        }
        failureAlert.addAction(confirmAction)
        present(failureAlert, animated: true)
    }
}

extension ProductSetupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImge = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImge
        }
        let newImageView = PickerImageView(frame: CGRect())
        newImageView.image = newImage
        productSetupView?.horizontalStackView.addArrangedSubview(newImageView)
        picker.dismiss(animated: true)
    }
}

extension ProductSetupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
