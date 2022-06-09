//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/25.
//

import UIKit

protocol ViewControllerDelegate: AnyObject {
    func viewControllerShouldRefresh(_ viewController: UIViewController)
}

final class RegisterViewController: RegisterEditBaseViewController {
    
    weak var delegate: ViewControllerDelegate?
    
    private enum Constant {
        static let navigationTitle = "상품등록"
        static let maximumImageViewCount = 6
        static let alertOk = "확인"
    }
    
    private let picker = UIImagePickerController()
    private let productRegisterUseCase = ProductRegisterUseCase(
        network: Network(),
        jsonEncoder: JSONEncoder()
    )
    
    private lazy var addImageButton: UIButton = {
        let imageButton = UIButton()
        let image = UIImage(systemName: "plus")
        imageButton.setImage(image, for: .normal)
        imageButton.backgroundColor = .systemGray5
        imageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        return imageButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        setBaseImage()
        navigationItem.title = Constant.navigationTitle
    }
}

// MARK: - Method
extension RegisterViewController {
    private func addImageToStackView(image: UIImage) {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        imageView.isUserInteractionEnabled = true
        imageView.image = image
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(deleteImageView))
        gesture.direction = .up
        imageView.addGestureRecognizer(gesture)
        
        addImageHorizontalStackView.addLastBehind(view: imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: addImageScrollView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        addImageButton.isHidden = (addImageHorizontalStackView.arrangedSubviews.count == Constant.maximumImageViewCount)
        addImageHorizontalStackView.setNeedsDisplay()
    }
    
   private func setBaseImage() {
        addImageHorizontalStackView.addArrangedSubview(addImageButton)
        
        NSLayoutConstraint.activate([
            addImageButton.heightAnchor.constraint(equalTo: addImageScrollView.heightAnchor),
            addImageButton.widthAnchor.constraint(equalTo: addImageButton.heightAnchor)
        ])
    }
    
    private func wrapperImage() -> [UIImage] {
        let imageArray = addImageHorizontalStackView.arrangedSubviews.compactMap {
            ($0 as? UIImageView)?.image
        }
        return imageArray
    }
    
    private func showErrorAlert(error: Error) {
        DispatchQueue.main.async {
            var alert: UIAlertController
            if let useCaseError = error as? ErrorAlertProtocol {
               alert = self.makeAlertAction(error: useCaseError)
            } else {
               alert = self.makeAlertAction(error: UnknownError.unknown)
            }
            let alertAction = UIAlertAction(title: Constant.alertOk,
                                            style: .default)
            alert.addAction(alertAction)
            self.present(alert, animated: true)
        }
    }
    
    private func makeAlertAction(error: ErrorAlertProtocol) -> UIAlertController {
        let alert = UIAlertController(title: error.alertTitle,
                                      message: error.alertMessage,
                                      preferredStyle: .alert)
        return alert
    }
}

// MARK: - Action Method
extension RegisterViewController {
    
    @objc private func addImage() {
        let alert = UIAlertController(
            title: "상품 이미지 추가",
            message: "",
            preferredStyle: .actionSheet
        )
        let library = UIAlertAction(
            title: "사진앨범",
            style: .default
        ) { (action) in
            self.openLibrary()
        }
        let cancel = UIAlertAction(
            title: "취소",
            style: .cancel,
            handler: nil
        )
        alert.addAction(library)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func deleteImageView(_ sender: UISwipeGestureRecognizer) {
        guard let imageView = sender.view, let stackView = imageView.superview as? UIStackView else { return }
        stackView.removeArrangedSubview(imageView)
        imageView.removeFromSuperview()
    }
    
    @objc override func registerEditViewRightBarButtonTapped() {
        guard let registrationParameter = wrapperRegistrationParameter() else {
            return
        }
        productRegisterUseCase.registerProduct(registrationParameter: registrationParameter,
                                               images: wrapperImage()) { _, _ in 
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.delegate?.viewControllerShouldRefresh(self)
                self.navigationController?.popViewController(animated: true)
            }
        } errorHandler: { [weak self] error in
            self?.showErrorAlert(error: error)
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            showErrorAlert(error: UseCaseError.imageError)
            return
        }
        addImageToStackView(image: selectedImage)
        picker.dismiss(animated: true)
    }
    
    private func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
}


