//
//  RegisterProductViewController.swift
//  OpenMarket
//
//  Created by Mangdi, woong on 2022/12/02.
//

import UIKit

class RegisterProductViewController: UIViewController {
    var networkCommunication = NetworkCommunication()
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)) as UIActivityIndicatorView
        indicator.hidesWhenStopped = true
        indicator.style = .large
        return indicator
    }()
    var imageSet: [UIImage] = []
    var mode: String = ""
    var productID: Int = 0
    var patchImages: [Image] = []
    var productData: DetailProduct?
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imagePlusButton: UIButton!
    @IBOutlet weak var imageStackView: UIStackView!
    
    @IBOutlet weak var productInformationStackView: UIStackView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productBargainPriceTextField: UITextField!
    @IBOutlet weak var productStockTextField: UITextField!
    @IBOutlet weak var productCurrencySegmentedControl: UISegmentedControl!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mode == "patch" {
            navigationBar.topItem?.title = "상품수정"
            imagePlusButton.isHidden = true
            requestImageDataWhenPatchMode()
            requestDetailDataWhenPatchMode()
        } else {
            imagePlusButton.setTitle("", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        productNameTextField.resignFirstResponder()
        productPriceTextField.resignFirstResponder()
        productBargainPriceTextField.resignFirstResponder()
        productStockTextField.resignFirstResponder()
        productDescriptionTextView.resignFirstResponder()
    }
    
    @IBAction func touchUpCancelBarButtonItem(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func touchUpDoneBarButtonItem(_ sender: UIBarButtonItem) {
        if mode == "patch" {
            requestPatchProductWhenPatchMode()
        } else {
            postProductWhenRegisterMode()
        }
    }
    
    @IBAction func touchUpImagePlusButton(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.modalPresentationStyle = .fullScreen
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        let navigationBarFramePointY = navigationBar.frame.origin.y
        
        if productDescriptionTextView.isFirstResponder {
            guard let keyboardFrame: NSValue =
                    notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let descriptionTextViewPointY = productDescriptionTextView.frame.origin.y
            
            if -descriptionTextViewPointY + navigationBarFramePointY < -keyboardHeight {
                self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            } else {
                self.view.transform = CGAffineTransform(translationX: 0,
                                                        y: -descriptionTextViewPointY +
                                                        navigationBarFramePointY)
            }
        } else {
            let stackViewFramePointY = productInformationStackView.frame.origin.y
            self.view.transform = CGAffineTransform(translationX: 0,
                                                    y: -stackViewFramePointY +
                                                    navigationBarFramePointY)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        view.transform = .identity
    }
    
    private func requestImageDataWhenPatchMode() {
        for patchImage in patchImages {
            let imageCacheKey = NSString(string: patchImage.thumbnailURL)
            
            if let imageCacheValue = ImageCacheManager.shared.object(forKey: imageCacheKey) {
                showImagesWhenPatchMode(image: imageCacheValue)
            } else {
                guard let imageUrl: URL = URL(string: patchImage.thumbnailURL) else { return }
                networkCommunication.requestImageData(url: imageUrl) { [weak self] data in
                    switch data {
                    case .success(let data):
                        DispatchQueue.main.async {
                            guard let image = UIImage(data: data) else { return }
                            ImageCacheManager.shared.setObject(image, forKey: imageCacheKey)
                            self?.showImagesWhenPatchMode(image: image)
                        }
                    case .failure(let error):
                        print(error.rawValue)
                    }
                }
            }
        }
    }
    
    private func requestDetailDataWhenPatchMode() {
        networkCommunication.requestProductsInformation(
            url: ApiUrl.Path.detailProduct + String(productID),
            type: DetailProduct.self
        ) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.productData = data
                    self?.showProductDataWhenPatchMode()
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func showImagesWhenPatchMode(image: UIImage) {
        let imageView = makeImageView(image: image)
        imageStackView.addArrangedSubview(imageView)
        imageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                          multiplier: 0.15).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor,
                                         multiplier: 1).isActive = true
    }
    
    private func showProductDataWhenPatchMode() {
        guard let productData = productData else { return }
        
        productNameTextField.text = productData.name
        productPriceTextField.text = String(productData.price)
        productBargainPriceTextField.text = String(productData.bargainPrice)
        productStockTextField.text = String(productData.stock)
        productCurrencySegmentedControl.selectedSegmentIndex = productData.currency == .KRW ? 0 : 1
        productDescriptionTextView.text = productData.description
    }
    
    private func requestPatchProductWhenPatchMode() {
        guard let productName = productNameTextField.text,
              let priceText = productPriceTextField.text,
              let productDescription = productDescriptionTextView.text,
              let discountedPriceText = productBargainPriceTextField.text,
              let stockText = productStockTextField.text else { return }
        
        let productCurrency: Currency =
        productCurrencySegmentedControl.selectedSegmentIndex == 0 ? .KRW : .USD
        
        guard let productPrice = Double(priceText),
              let productDiscountedPrice = Double(discountedPriceText) else { return }
        let productStock = Int(stockText) ?? 0
        
        if productName.count < 3 ||  productName.count > 100 {
            resisterProductAlert(message: "상품명은 3~100자를 입력하셔야합니다.", success: false)
            return
        }
        
        if productDescription.count < 10 || productDescription.count > 1000 {
            resisterProductAlert(message: "상품상세정보는 10~1000자를 입력하셔야합니다.", success: false)
            return
        }
        
        if productDiscountedPrice < 0 || productDiscountedPrice > productPrice {
            resisterProductAlert(message: "할인가는 0보다 높거나 상품가보다 낮아야 합니다.", success: false)
            return
        }
        
        // 썸네일 ID 전해주는거 수정 (썸네일 이미지 바꾸는거 아직 안함)
        requestPatch(productID: productID,
                     name: productName,
                     description: productDescription,
                     thumbnailID: 0,
                     price: productPrice,
                     currency: productCurrency,
                     discountedPrice: productDiscountedPrice,
                     stock: productStock)
        
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    
    private func postProductWhenRegisterMode() {
        guard let productName = productNameTextField.text,
              let priceText = productPriceTextField.text,
              let productDescription = productDescriptionTextView.text,
              let discountedPriceText = productBargainPriceTextField.text,
              let stockText = productStockTextField.text else { return }
        
        let productCurrency: Currency =
        productCurrencySegmentedControl.selectedSegmentIndex == 0 ? .KRW : .USD
        
        let stackFirstView = imageStackView.arrangedSubviews.first
        guard let _ = stackFirstView as? UIImageView else {
            resisterProductAlert(message: "이미지가 등록되지 않았습니다.\n 확인해주세요.", success: false)
            return
        }
        
        if productName == "" || priceText == "" || productDescription == "" {
            resisterProductAlert(message: "입력되지 않은 필드가 있습니다.\n 확인해주세요.", success: false)
        } else {
            for subView in imageStackView.arrangedSubviews {
                if let imageView = subView as? UIImageView,
                   let image = imageView.image {
                    imageSet.append(image)
                }
            }
            
            guard let productPrice = Int(priceText) else { return }
            let productDiscountedPrice = Int(discountedPriceText) ?? 0
            let productStock = Int(stockText) ?? 0
            
            requestPost(name: productName,
                        description: productDescription,
                        price: productPrice,
                        currency: productCurrency,
                        discountPrice: productDiscountedPrice,
                        stock: productStock,
                        secret: Secret.password)
            
            loadingIndicator.center = view.center
            view.addSubview(loadingIndicator)
            loadingIndicator.startAnimating()
            
        }
        imageSet = []
    }
    
    private func makeImageView(image: UIImage) -> UIImageView {
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            return imageView
        }()
        return imageView
    }
    
    private func resisterProductAlert(message: String, success: Bool) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "닫기", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        let noAction = UIAlertAction(title: "닫기", style: .default)
        
        alert.addAction(success ? okAction : noAction)
        present(alert, animated: true)
    }
    
    private func requestPost(name: String,
                             description: String,
                             price: Int,
                             currency: Currency,
                             discountPrice: Int,
                             stock: Int,
                             secret: String) {
        networkCommunication.requestPostData(url: ApiUrl.Path.products,
                                             images: imageSet,
                                             name: name,
                                             description: description,
                                             price: price,
                                             currency: currency,
                                             discountPrice: discountPrice,
                                             stock: stock,
                                             secret: secret) { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.loadingIndicator.removeFromSuperview()
            }
            switch result {
            case .success(let statusCode):
                DispatchQueue.main.async {
                    self?.resisterProductAlert(message: "\(statusCode):\n 상품이 성공적으로 등록되었습니다.", success: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.resisterProductAlert(message: "\(error.rawValue)", success: false)
                }
            }
        }
    }
    
    private func requestPatch(productID: Int,
                              name: String,
                              description: String,
                              thumbnailID: Int,
                              price: Double,
                              currency: Currency,
                              discountedPrice: Double,
                              stock: Int) {
        networkCommunication.requestPatchData(url: ApiUrl.Path.detailProduct+String(productID),
                                              name: name,
                                              description: description,
                                              thumbnailID: thumbnailID,
                                              price: price,
                                              currency: currency,
                                              discountedPrice: discountedPrice,
                                              stock: stock,
                                              secret: Secret.password) { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.loadingIndicator.removeFromSuperview()
            }
            switch result {
            case .success(let statusCode):
                DispatchQueue.main.async {
                    self?.resisterProductAlert(message: "\(statusCode):\n 상품이 성공적으로 수정되었습니다.", success: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.resisterProductAlert(message: "\(error.rawValue)", success: false)
                }
            }
        }
    }
}

extension RegisterProductViewController: UIImagePickerControllerDelegate,
                                         UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            let imageView = makeImageView(image: image)
            imageStackView.addArrangedSubview(imageView)
            imageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                              multiplier: 0.15).isActive = true
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor,
                                             multiplier: 1).isActive = true
            imageStackView.insertArrangedSubview(imagePlusButton,
                                                 at: imageStackView.arrangedSubviews.endIndex)
        }
        
        if imageStackView.arrangedSubviews.count >= 6 {
            imagePlusButton.isHidden = true
        }
        dismiss(animated: true)
    }
}
