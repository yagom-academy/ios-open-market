//
//  RegistrationViewController.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

final class RegistrationViewController: UIViewController {
  private lazy var registrationView = RegistrationView()
  private let picker = UIImagePickerController()
  private let apiProvider = ApiProvider<ProductsList>()
  private var selectedImages: [ImageFile] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureRegistration()
    configureNavigationBar()
    didTapAddImageButton()
    self.picker.delegate = self
  }
  
  private func configureRegistration() {
    let safeArea = self.view.safeAreaLayoutGuide
    self.view.addSubview(registrationView)
    
    NSLayoutConstraint.activate(
      [registrationView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
       registrationView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
       registrationView.topAnchor.constraint(equalTo: safeArea.topAnchor),
       registrationView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
      ])
  }
  
  private func configureNavigationBar() {
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(cancelModal))
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                             target: self,
                                                             action: #selector(postData))
    self.navigationItem.title = "상품등록"
    
    self.navigationController?.navigationBar.backgroundColor = .white
    self.navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
  }
  
  @objc private func cancelModal() {
    self.dismiss(animated: true, completion: nil)
  }
  
  private func didTapAddImageButton() {
    registrationView.addImageButton.addTarget(self, action: #selector(presentAlert), for: .touchUpInside)
  }
  
  @objc private func postData() {
    let params = registrationView.setupParams()
    apiProvider.post(.registration, params, selectedImages) { result in
      switch result {
      case .success(_):
        return
      case .failure(let response):
        print(response)
        return
      }
    }
  }
}
//MARK: - alert
extension RegistrationViewController {
  @objc private func presentAlert() {
    let alert = UIAlertController(title: "선택", message: "선택", preferredStyle: .alert)
    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    let album = UIAlertAction(title: "앨범", style: .default) { [weak self] (_) in
      self?.presentAlbum()
    }
    
    alert.addAction(cancel)
    alert.addAction(album)
    
    present(alert, animated: true, completion: nil)
  }
}

extension RegistrationViewController: UIImagePickerControllerDelegate,
                                      UINavigationControllerDelegate {
  func presentAlbum(){
    picker.sourceType = .photoLibrary
    picker.allowsEditing = true
    present(picker, animated: false, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      guard let resizePickerImage = resizeImage(image: image, newWidth: 300) else {
        return
      }
      registrationView.imageStackView.addArrangedSubview(setUpImage(image))
      convertToImageFile(resizePickerImage)
    }
    dismiss(animated: true, completion: nil)
  }
  
  func convertToImageFile(_ image: UIImage) {
    guard let imageData = image.jpegData(compressionQuality: 1) else {
      return
    }
    let imageFile = ImageFile(fileName: "imageName.jpeg", type: "jpeg", data: imageData)
    self.selectedImages.append(imageFile)
  }
  
  func setUpImage(_ image: UIImage) -> UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = image
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1).isActive = true
    
    return imageView
  }
  
  func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
}

