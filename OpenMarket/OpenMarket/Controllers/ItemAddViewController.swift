//
//  ItemAddViewController.swift
//  OpenMarket
//
//  Created by leewonseok on 2022/11/25.
//

import UIKit

final class ItemAddViewController: ItemViewController {
    // MARK: - Property
    private let registrationImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(presentAlbum), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImage()
    }
}

extension ItemAddViewController {
    // MARK: - View Constraint
    private func configureImage() {
        self.imageStackView.addArrangedSubview(registrationImageView)
        self.registrationImageView.addSubview(registrationButton)
        
        NSLayoutConstraint.activate([
            self.registrationImageView.widthAnchor.constraint(equalToConstant: 130),
            self.registrationImageView.heightAnchor.constraint(equalToConstant: 130),
            
            self.registrationButton.topAnchor.constraint(equalTo: self.registrationImageView.topAnchor),
            self.registrationButton.bottomAnchor.constraint(equalTo: self.registrationImageView.bottomAnchor),
            self.registrationButton.leadingAnchor.constraint(equalTo: self.registrationImageView.leadingAnchor),
            self.registrationButton.trailingAnchor.constraint(equalTo: self.registrationImageView.trailingAnchor)
        ])
    }
    
}
extension ItemAddViewController {
    // MARK: - Method
    override func configureNavigation() {
        super.configureNavigation()
        self.navigationItem.title = "상품생성"
    }
    
    override func doneButtonTapped() {
        let priceText = priceTextField.text ?? "0"
        let discountedPriceText = discountedPriceTextField.text ?? "0"
        let stockText = stockTextField.text ?? "0"

        guard isPost == false else {
            showAlert(title: "경고", message: "처리 중 입니다.", actionTitle: "확인", dismiss: false)
            return
        }
        guard itemImages.count > 0 else {
            showAlert(title: "경고", message: "이미지를 등록해주세요.", actionTitle: "확인", dismiss: false)
            return
        }

        guard let itemNameText =  itemNameTextField.text,
              itemNameText.count > 2 else {
            showAlert(title: "경고", message: "제목을 3글자 이상 입력해주세요.", actionTitle: "확인", dismiss: false)
            return
        }


        guard let price = Double(priceText),
              let discountPrice = Double(discountedPriceText),
              let stock = Int(stockText) else {
            showAlert(title: "경고", message: "유효한 숫자를 입력해주세요", actionTitle: "확인", dismiss: false)
            return
        }

        guard let descriptionText = descriptionTextView.text,
              descriptionText.count <= 1000 else {
            showAlert(title: "경고", message: "내용은 1000자 이하만 등록가능합니다.", actionTitle: "확인", dismiss: false)
            return
        }

        let parameter: [String: Any] = ["name": itemNameText,
                                     "price": price,
                                     "currency": currencySegmentedControl.selectedSegmentIndex == 0
                                                    ? Currency.krw.rawValue: Currency.usd.rawValue,
                                     "discounted_price": discountPrice,
                                     "stock": stock,
                                     "description": descriptionText,
                                     "secret": NetworkManager.secret]
        self.isPost = true
        LoadingController.showLoading()
        networkManager.addItem(parameter: parameter, images: itemImages) { result in
            LoadingController.hideLoading()

            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.showAlert(title: "성공", message: "등록에 성공했습니다", actionTitle: "확인", dismiss: true)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(title: "실패", message: "등록에 실패했습니다", actionTitle: "확인", dismiss: false)
                }
            }

            self.isPost = false
        }
    }
}

// MARK: - UIImagePicker
extension ItemAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc private func presentAlbum(){
        guard itemImages.count < 5 else {
            return showAlert(title: "경고", message: "5개 이하의 이미지만 등록할 수 있습니다.", actionTitle: "확인", dismiss: false)
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.itemImages.append(image)
            self.imageStackView.insertArrangedSubview(UIImageView(image: image), at: 0)
        }
        
        dismiss(animated: true)
    }
}

