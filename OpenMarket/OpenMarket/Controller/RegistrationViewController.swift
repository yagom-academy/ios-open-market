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
                                                             action: #selector(cancelModal))
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
    present(picker, animated: false, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
      registrationView.imageStackView.addArrangedSubview(setUpImage(image))
      print(registrationView.imageStackView)
    }
    dismiss(animated: true, completion: nil)
  }
  
  func setUpImage(_ image: UIImage) -> UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = image
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1).isActive = true
    
    return imageView
  }
}

