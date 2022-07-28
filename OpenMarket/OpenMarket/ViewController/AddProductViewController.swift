//
//  ProductViewController.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/27.
//

import UIKit

class AddProductViewController: UIViewController {
    private let productView = AddProductView()
    private var dataSource = [UIImage(systemName: "plus")]
    private let imagePicker = UIImagePickerController()
    private var imageParams: [ImageParam] = []

    lazy var viewConstraint = productView.entireStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -260)
    
    override func loadView() {
        super.loadView()
        view = productView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureDelegate()
        configureImagePicker()
    }
    
    private func configureUI() {
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(goBack))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(goBackWithUpdate))
        navigationItem.title = "상품등록"
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = doneBarButton
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func configureDelegate() {
        productView.collectionView.dataSource = self
        productView.collectionView.delegate = self
        productView.descriptionTextView.delegate = self
    }
    
    private func configureImagePicker() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }

    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func goBackWithUpdate() {
        let sessionManager = URLSessionManager(session: URLSession.shared)
        guard let param = productView.receiveParam() else { return }
        
        guard param.productName != "", param.price != "", param.description != "" else { return }
        
        guard dataSource.count != 1 else { return }
            
        var dataElement: [[String : Any]] = [
            [
                "key": "params",
                "value": """
                        {
                            "name": "\(param.productName)",
                            "price": \(param.price),
                            "stock": \(param.stock),
                            "currency": "\(param.currency)",
                            "secret": "\(param.secret)",
                            "descriptions": "\(param.description)"
                        }
                        """,
                "type": "text"
            ]
        ]
        
        for image in imageParams {
            let imageElement: [String : Any] =  [
                "key": "images",
                "src": "\(image.imageName)",
                "image": image.imageData,
                "type": "\(image.imageType)"
            ]
            
            dataElement.append(imageElement)
        }
        
        sessionManager.postData(dataElement: dataElement) { result in
            switch result {
            case .success(_):
                print("성공!")
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.showAlert(title: "서버 통신 실패", message: "데이터를 올리지 못했습니다.")
                }
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddProductViewController: UICollectionViewDataSource {
    func collectionView( _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.dataSource.count
    }
    
    func collectionView( _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddProductCollectionViewCell.id, for: indexPath) as? AddProductCollectionViewCell ?? AddProductCollectionViewCell()
        cell.productImage.image = dataSource[indexPath.item]
        return cell
    }
}

extension AddProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 5 && indexPath.row == dataSource.count - 1 {
            self.present(self.imagePicker, animated: true)
        }
        
        if indexPath.row == 5 {
            showAlert(title: "사진 등록 불가능", message: "사진은 최대 5장까지 가능합니다.")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let failureAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        failureAlert.addAction(UIAlertAction(title: "확인", style: .default))
        present(failureAlert, animated: true)
    }
}

extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage = UIImage()
        
        if let newImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = newImage
        } else if let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = newImage
        }

        dataSource.insert(selectedImage, at: 0)
        imageParams.append(ImageParam(imageName: "\(dataSource.count - 1)번사진.jpeg", imageData: selectedImage))
        
        picker.dismiss(animated: true, completion: nil)
        productView.collectionView.reloadData()
    }
}

extension AddProductViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        viewConstraint.isActive = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        viewConstraint.isActive = false
    }
}
