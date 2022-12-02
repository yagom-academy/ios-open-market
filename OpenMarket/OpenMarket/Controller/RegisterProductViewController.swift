//
//  RegisterProductViewController.swift
//  OpenMarket
//
//  Created by Mangdi on 2022/12/02.
//

import UIKit

class RegisterProductViewController: UIViewController {
    let networkCommunication = NetworkCommunication()
    
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
        let productCurrency = productCurrencySegmentedControl.selectedSegmentIndex
        if productNameTextField.text == "" ||
            productPriceTextField.text == "" ||
            productDescriptionTextView.text == "" {
            resisterProductAlert(message: "입력되지 않은 필드가 있습니다.\n 확인해주세요.", success: false)
        } else {
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
            self?.dismiss(animated: true)}
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
