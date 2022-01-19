//
//  ProductRegistrationModificationViewController22.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/19.
//

import UIKit

class ProductRegistrationModificationViewController22: UIViewController {
  
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var fixedPriceTextField: UITextField!
  @IBOutlet weak var bargainPriceTextField: UITextField!
  @IBOutlet weak var stockTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var currencySegmentControl: UISegmentedControl!
  
  private var images: [UIImage] = []
  private var imageAddition: [UIImage] = []
  
  @IBAction func button(_ sender: Any) {
    if images.count < 5 {
      presentAlbum()
    } else {
      showAlert(message: "이미지는 5개까지 등록 가능합니다.")
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  func presentAlbum(){
    let vc = UIImagePickerController()
    vc.sourceType = .photoLibrary
    vc.delegate = self
    vc.allowsEditing = true
    
    present(vc, animated: true, completion: nil)
  }
  
  func appendImageView(image: UIImage) {
    let imageView = UIImageView(image: image)
    imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1).isActive = true
    stackView.addArrangedSubview(imageView)
  }
  
}
extension ProductRegistrationModificationViewController22: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[.editedImage] as? UIImage {
      images.append(image)
      appendImageView(image: image)
    }
    dismiss(animated: true, completion: nil)
  }
}
