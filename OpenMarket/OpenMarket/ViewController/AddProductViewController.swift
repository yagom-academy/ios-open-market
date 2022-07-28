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

    override func loadView() {
        super.loadView()
        view = productView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        productView.collectionView.dataSource = self
        productView.collectionView.delegate = self
        configureImagePicker()
    }

    func configureUI() {
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(goBack))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(goBackWithUpdate))
        navigationItem.title = "상품등록"
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = doneBarButton
        navigationItem.setHidesBackButton(true, animated: false)
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
        var selectedImage: UIImage? = nil
        
        if let newImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = newImage
        } else if let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = newImage
        }
    
        dataSource.insert(selectedImage, at: 0)
        picker.dismiss(animated: true, completion: nil)
        productView.collectionView.reloadData()
    }
}
