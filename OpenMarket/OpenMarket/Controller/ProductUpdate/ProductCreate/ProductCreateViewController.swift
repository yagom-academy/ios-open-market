//
//  ProductCreateViewController.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/20.
//

import UIKit

final class ProductCreateViewController: ProductUpdateViewController {
    
    private(set) lazy var viewModel = ProductCreateViewModel(viewHandler: self.updateImageStackView)
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private let imagePicker = UIImagePickerController(allowsEditing: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImagePicker()
        configureTargetAction()
    }
    
    func updateImageStackView() {
        DispatchQueue.main.async {
            self.productRegisterView.productImageStackView.subviews.forEach {
                $0.removed(from: self.productRegisterView.productImageStackView, whenTypeIs: UIImageView.self)
            }
            self.viewModel.images.forEach {
                self.productRegisterView.productImageStackView.insertArrangedSubview(UIImageView(with: $0), at: 0)
            }
        }
    }
    
    private func imageAddbuttonClicked(_ sender: Any) {
        guard viewModel.canAddImage else {
            let title = "첨부할 수 있는 이미지가 초과되었습니다"
            let message = "새로운 이미지를 첨부하려면 기존의 이미지를 제거해주세요!"
            presentAcceptAlert(with: title, description: message)
            return
        }
        presentImagePickerAlert()
    }
    
    @IBAction func doneButtonClicked(_ sender: UIBarButtonItem) {
        activityIndicator.startAnimating()
        do {
            try viewModel.process(form, completionHandler: completionHandler)
        } catch {
            failureHandler(error: error)
        }
    }
    
    private func completionHandler(_ result: Result<CreateProductResponse, Error>) {
        DispatchQueue.main.async {
            switch result {
            case.success(_):
                self.activityIndicator.stopAnimating()
                self.dismiss(animated: true)
            case .failure(let error):
                self.failureHandler(error: error)
            }
        }
    }
    
    private func failureHandler(error: Error) {
        let title = "오류"
        let message = error.localizedDescription
        self.activityIndicator.stopAnimating()
        self.presentAcceptAlert(with: title, description: message)
    }
    
}

// MARK: - Configure View Controller
private extension ProductCreateViewController {
    
    func configureImagePicker() {
        imagePicker.delegate = self
    }
    
    func configureTargetAction() {
        let addButton: UIButton = productRegisterView.productImageAddButton
        let action = UIAction(handler: imageAddbuttonClicked)
        addButton.addAction(action, for: .touchUpInside)
    }
    
}

// MARK: - UIImagePicker Delegate Implements
extension ProductCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func openCamera(_ action: UIAlertAction) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let title = "카메라를 사용할 수 없습니다."
            let message = "카메라를 사용할 수 있는 환경인지 확인해주세요!"
            presentAcceptAlert(with: title, description: message)
            return
        }
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    private func openPhotoLibrary(_ action: UIAlertAction) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            let title = "앨범을 사용할 수 없습니다."
            let message = "앨범을 사용할 수 있는 환경인지 확인해주세요!"
            presentAcceptAlert(with: title, description: message)
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    private func presentImagePickerAlert() {
        let alert = UIAlertController(
            title: "사진을 불러옵니다",
            message: "어디서 불러올까요?",
            preferredStyle: .actionSheet
        )
        alert.addAction(title: "카메라", style: .default, handler: openCamera)
        alert.addAction(title: "앨범", style: .default, handler: openPhotoLibrary)
        alert.addAction(title: "취소", style: .cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            viewModel.append(image: image)
        }
        dismiss(animated: true)
    }
    
}
