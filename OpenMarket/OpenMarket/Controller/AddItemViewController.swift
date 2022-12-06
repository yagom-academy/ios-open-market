//
//  EmptyViewController.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/27.
//

import UIKit

final class AddItemViewController: UIViewController {
    let addItemView = AddItemView()
    var productImages: [UIImage] = []
    var params: Param?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationBar()
        configureLayout()
        configureImagePicker()
    }
    
    private func configureNavigationBar() {
        self.title = "상품등록"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                                style: .plain,
                                                                target: self, action:
                                                                    #selector(tappedCancel(sender:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(tappedDone(sender:)))
    }
    
    @objc private func tappedCancel(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func tappedDone(sender: UIBarButtonItem) {
        guard let productNameText = addItemView.productNameTextField.text,
              productNameText.count >= 3 else {
                  showAlertController(title: "상품명 글자수 제한", message: "3자 이상 입력이 되어야 합니다.")
                  return
              }
        
        guard addItemView.descTextView.text.count >= 1 && addItemView.descTextView.text.count <= 1000 else {
            showAlertController(title: "상품 설명 글자수 제한", message: "1자 이상 1000자 이하 입력이 되어야 합니다.")
            return
        }
        
        guard let priceText = addItemView.priceTextField.text,
              !priceText.isEmpty else {
                  showAlertController(title: "가격 미입력", message: "가격이 입력되지 않았습니다. 다시 입력해주세요.")
                  return
              }
        
        
        postItemImageDatas()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func postItemImageDatas() {
        guard let encodingData = JSONConverter.shared.encodeJson(param: params) else {
            return
        }
        
        HTTPManager.shared.requestPOST(url: OpenMarketURL.postProductComponent.url, encodingData: encodingData, images: productImages) { data in
            print("성공!")
        }
    }
}

extension AddItemViewController {
    func configureLayout() {
        self.view.addSubview(addItemView)
        
        addItemView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addItemView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            addItemView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            addItemView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            addItemView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension AddItemViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func configureImagePicker() {
        self.addItemView.registrationButton.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
    }
    
    @objc func showImagePicker() {
        guard productImages.count <= 4 else {
            showAlertController(title: "이미지 등록 불가", message: "이미지는 5개까지 등록이 가능합니다.")
            return
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
        let lastIndex = productImages.count
        
        if let image = info[.editedImage] as? UIImage, productImages.isEmpty {
            self.addItemView.imageStackView.insertArrangedSubview(UIImageView(image: image), at: 0)
            self.productImages.append(image)
        } else if let image = info[.editedImage] as? UIImage, productImages.isEmpty == false {
            self.addItemView.imageStackView.insertArrangedSubview(UIImageView(image: image), at: lastIndex)
            self.productImages.append(image)
        }
        
        dismiss(animated: true)
    }
}

extension AddItemViewController {
    func showAlertController(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: "\(title)",
                                                         message: "\(message)",
                                                         preferredStyle: .alert)
        
        let action: UIAlertAction = UIAlertAction(title: "확인",
                                                  style: .default,
                                                  handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
