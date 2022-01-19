//
//  ProductRegistrationModificationViewController.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/19.
//

import UIKit

class ProductRegistrationModificationViewController: UIViewController, ImagePickerable {
  @IBOutlet weak var mainScrollView: UIScrollView!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var fixedPriceTextField: UITextField!
  @IBOutlet weak var bargainPriceTextField: UITextField!
  @IBOutlet weak var stockTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var currencySegmentControl: UISegmentedControl!
  
  private var images: [UIImage] = []
  private var imageAddition: [UIImage] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    keyboardNotification()
  }
  
  @IBAction private func button(_ sender: Any) {
    if images.count < 5 {
      actionSheetAlertForImage()
    } else {
      showAlert(message: "이미지는 5개까지 등록 가능합니다.")
    }
  }
  
  private func appendImageView(image: UIImage) {
    let imageView = UIImageView(image: image)
    stackView.addArrangedSubview(imageView)
    imageView.heightAnchor.constraint(
      equalTo: imageView.widthAnchor,
      multiplier: 1
    ).isActive = true
  }
}

extension ProductRegistrationModificationViewController {
  private func keyboardNotification() {
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(_:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(_:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  
  @objc private func endEditing(){
    view.endEditing(true)
  }
  
  @objc private func keyboardWillShow(_ sender: Notification) {
    guard let userInfo = sender.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
          }
    let keyboardHeight = keyboardFrame.size.height
    let contentInset = UIEdgeInsets(
      top: 0.0,
      left: 0.0,
      bottom: keyboardHeight,
      right: 0.0
    )
    mainScrollView.contentInset = contentInset
    mainScrollView.scrollIndicatorInsets = contentInset
  }
  
  @objc private func keyboardWillHide(_ sender: Notification) {
    let contentInset = UIEdgeInsets.zero
    mainScrollView.contentInset = contentInset
    mainScrollView.scrollIndicatorInsets = contentInset
  }
}

extension ProductRegistrationModificationViewController {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else {
      dismiss(animated: true, completion: nil)
      showAlert(message: "이미지를 불러오지 못했습니다.")
      return
    }
    let resizingImage = image.resize(maxBytes: 307200)
    images.append(resizingImage)
    appendImageView(image: resizingImage)
    dismiss(animated: true, completion: nil)
  }
}
