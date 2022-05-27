//
//  RegistrationViewController.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

final class RegistrationViewController: UIViewController {
  private enum Constants {
    static let navigationBarTitle = "상품등록"
    static let pickerAlertTitle = "사진 선택"
    static let pickerAlertMessage = "사진을 등록하시겠습니까?"
    static let pickerAlertCancelText = "취소"
    static let pickerAlertAlbumText = "앨범"
    static let warningAlertTitle = "입력하지 않은 정보가 있습니다."
    static let warningAlertMessage = "다시 한번 확인해주세요."
    static let warningAlertCancelText = "확인"
    static let maxImageCount = 5
  }
  
  private let apiProvider = ApiProvider()
  private lazy var registrationView = RegistrationView()
  private let picker = UIImagePickerController()
  private var selectedImages: [ImageFile] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureRegistrationView()
    addNotification()
    addGestureRecognizer()
    picker.delegate = self
  }
  
  private func configureRegistrationView() {
    let safeArea = self.view.safeAreaLayoutGuide
    self.view.addSubview(registrationView)
    
    NSLayoutConstraint.activate([
      registrationView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      registrationView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      registrationView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      registrationView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
    
    configureNavigationBar()
    didTapAddImageButton()
  }
  
  private func configureNavigationBar() {
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(cancelModal))
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                             target: self,
                                                             action: #selector(postData))
    self.navigationItem.title = Constants.navigationBarTitle
    
    self.navigationController?.navigationBar.backgroundColor = .white
    self.navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
  }
  
  @objc private func cancelModal() {
    self.dismiss(animated: true, completion: nil)
  }
  
  private func didTapAddImageButton() {
    registrationView.addImageButton.addTarget(self,
                                              action: #selector(presentPickerAlert),
                                              for: .touchUpInside)
  }
  
  @objc private func postData() {
    let params = registrationView.setupParams()
    
    guard let params = params, !self.selectedImages.isEmpty else {
      presentWarningAlert()
      return
    }
    
    let group = DispatchGroup()
    DispatchQueue.global().async(group: group) {
      self.apiProvider.post(.registration, params, self.selectedImages) { result in
        switch result {
        case .success(_):
          return
        case .failure(let response):
          print(response)
          return
        }
      }
    }
    group.notify(queue: .main) {
      self.dismiss(animated: true, completion: nil)
    }
  }
}
//MARK: - alert
extension RegistrationViewController {
  @objc private func presentPickerAlert() {
    let alert = UIAlertController(title: Constants.pickerAlertTitle,
                                  message: Constants.pickerAlertMessage, preferredStyle: .alert)
    let cancel = UIAlertAction(title: Constants.pickerAlertCancelText, style: .cancel, handler: nil)
    let album = UIAlertAction(title: Constants.pickerAlertAlbumText, style: .default) { [weak self] (_) in
      self?.presentAlbum()
    }
    
    alert.addAction(cancel)
    alert.addAction(album)
    
    present(alert, animated: true, completion: nil)
  }
  
  private func presentWarningAlert() {
    let alert = UIAlertController(title: Constants.warningAlertTitle,
                                  message: Constants.warningAlertMessage, preferredStyle: .alert)
    let cancel = UIAlertAction(title: Constants.warningAlertCancelText, style: .cancel, handler: nil)
    
    alert.addAction(cancel)
    
    present(alert, animated: true, completion: nil)
  }
}
//MARK: - ImagePickerController
extension RegistrationViewController: UIImagePickerControllerDelegate,
                                      UINavigationControllerDelegate {
  func presentAlbum() {
    picker.sourceType = .photoLibrary
    picker.allowsEditing = true
    present(picker, animated: false, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo
                             info: [UIImagePickerController.InfoKey : Any])
  {
    if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      guard let resizePickerImage = resize(image: image, newWidth: 300) else {
        return
      }
      registrationView.imageStackView.addArrangedSubview(setUpImageView(with: image))
      convertToImageFile(from: resizePickerImage)
    }
    if self.selectedImages.count == Constants.maxImageCount {
      registrationView.addImageButton.isHidden = true
    }
    dismiss(animated: true, completion: nil)
  }
  
  func setUpImageView(with image: UIImage) -> UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = image
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
    
    return imageView
  }
  
  func convertToImageFile(from image: UIImage) {
    guard let imageData = image.jpegData(compressionQuality: 1) else {
      return
    }
    let imageFile = ImageFile(data: imageData)
    self.selectedImages.append(imageFile)
  }
  
  func resize(image: UIImage, newWidth: CGFloat) -> UIImage? {
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
}
