//
//  ProductSetupViewController.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/28.
//

import UIKit

class ProductSetupViewController: UIViewController {
    // MARK: - Properties
    private let manager = NetworkManager.shared
    private var productSetupView: ProductSetupView?
    private var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        productSetupView = ProductSetupView(self)
        setupKeyboard()
        setupPickerViewController()
    }
    @objc func keyboardWillAppear(_ sender: Notification) {
        print("keyboard up")
    }
    @objc func keyboardWillDisappear(_ sender: Notification){
        print("keyboard down")
    }
    @objc func cancelButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func doneButtonDidTapped() {
        guard let productRegistration = createProductRegistration(),
              let images = createImages()
        else {
            return
        }
        manager.requestProductRegistration(with: productRegistration, images: images) { detail in
            print("SUCCESS POST - \(detail.id), \(detail.name)")
            DispatchQueue.main.async {
                self.showAlert(title: "알림", message: "게시 완료!!") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func createProductRegistration() -> ProductRegistration? {
        guard let productSetupView = productSetupView,
              let productName = productSetupView.productNameTextField.text,
              let price = Double(productSetupView.productPriceTextField.text ?? ""),
              let discountedPrice = Double(productSetupView.productDiscountedPriceTextField.text ?? ""),
              let stock = Int(productSetupView.productStockTextField.text ?? "")
        else {
            showAlert(title: "알림", message: "텍스트필드에 값을 넣어주세요")
            return nil
        }
        let currency = productSetupView.currencySegmentControl.selectedSegmentIndex == 0 ? Currency.krw : Currency.usd
        let productRegistration = ProductRegistration(name: productName,
                                                      descriptions: productSetupView.descriptionTextView.text,
                                                      price: price,
                                                      currency: currency,
                                                      discountedPrice: discountedPrice,
                                                      stock: stock,
                                                      secret: URLData.secret
        )
        return productRegistration
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
    
    private func setupKeyboard() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidTapped))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    private func setupPickerViewController() {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        productSetupView?.addImageButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
    }
    
    @objc func pickImage() {
        if productSetupView?.horizontalStackView.subviews.count == 6 {
            showAlert(title: "추가할 수 없습니다", message: "5장 이상은 추가 할 수 없습니다.")
            return
        }
        self.present(imagePicker, animated: true)
    }
    
    func showAlert(title: String, message: String, _ completion: (() -> Void)? = nil) {
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
