//
//  RegisterProductViewController.swift
//  OpenMarket
//
//  Created by Mangdi on 2022/12/02.
//

import UIKit

class RegisterProductViewController: UIViewController {
    let networkCommunication = NetworkCommunication()
    var imageSet: [UIImage] = []
    
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imagePlusButton: UIButton!
    @IBOutlet weak var imageStackView: UIStackView!
    
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
    
    @IBAction func touchUpCancelBarButtonItem(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func touchUpDoneBarButtonItem(_ sender: UIBarButtonItem) {
        guard let productName = productNameTextField.text,
              let priceText = productPriceTextField.text,
              let productDescription = productDescriptionTextView.text,
              let discountedPriceText = productDiscountedPriceTextField.text,
              let stockText = productStockTextField.text else { return }
        
        let productCurrency: Currency
        if productCurrencySegmentedControl.selectedSegmentIndex == 0 {
            productCurrency = .KRW
        } else {
            productCurrency = .USD
        }
        
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
            
            // 이미지5장 안보내지는거 확인!!!
            networkCommunication.requestPostData(url: ApiUrl.Path.products,
                                                 images: imageSet,
                                                 name: productName,
                                                 description: productDescription,
                                                 price: productPrice,
                                                 currency: productCurrency,
                                                 discountPrice: productDiscountedPrice,
                                                 stock: productStock,
                                                 secret: "fne3fgu2k6a4r9wu")
            resisterProductAlert(message: "상품이 성공적으로 등록되었습니다.", success: true)
        }
    }
    
    @IBAction func touchUpImagePlusButton(_ sender: UIButton) {
        presentAlbum()
    }
    
    private func presentAlbum() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.modalPresentationStyle = .fullScreen
        present(imagePickerController, animated: true, completion: nil)
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
    
}

extension RegisterProductViewController: UIImagePickerControllerDelegate,
                                         UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            let imageView = makeImageView(image: image)
            imageStackView.addArrangedSubview(imageView)
            // constraints를 stackview에 추가하기전에 써주면 왜 에러가 나는가
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
