//
//  RegisterProductViewController.swift
//  OpenMarket
//
//  Created by Mangdi, woong on 2022/12/02.
//

import UIKit

class RegisterProductViewController: UIViewController {
    let networkCommunication = NetworkCommunication()
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
    @IBOutlet weak var productDiscountedPriceTextField: UITextField!
    @IBOutlet weak var productStockTextField: UITextField!
    @IBOutlet weak var productCurrencySegmentedControl: UISegmentedControl!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePlusButton.setTitle("", for: .normal)
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
        productDiscountedPriceTextField.resignFirstResponder()
        productStockTextField.resignFirstResponder()
        productDescriptionTextView.resignFirstResponder()
    }
    
    @IBAction func touchUpCancelBarButtonItem(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func touchUpDoneBarButtonItem(_ sender: UIBarButtonItem) {
        guard let productName = productNameTextField.text,
              let priceText = productPriceTextField.text,
              let productDescription = productDescriptionTextView.text,
              let discountedPriceText = productDiscountedPriceTextField.text,
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
                        secret: "fne3fgu2k6a4r9wu")
            
            loadingIndicator.center = view.center
            view.addSubview(loadingIndicator)
            loadingIndicator.startAnimating()
            
        }
        imageSet = []
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
            switch result {
            case .success(let statusCode):
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
                    self?.resisterProductAlert(message: "\(statusCode):\n 상품이 성공적으로 등록되었습니다.", success: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
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
