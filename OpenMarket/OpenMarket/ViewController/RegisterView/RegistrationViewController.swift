//
//  RegistrationViewController.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/12/01.
//

import UIKit

class RegistrationViewController: UIViewController {
    let registrationView: RegistrationView = RegistrationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        registrationView.imageCollectionView.delegate = self
        registrationView.imageCollectionView.dataSource = self
        registrationView.imageCollectionView.register(
            ImageCollectionViewCell.self,
            forCellWithReuseIdentifier: ImageCollectionViewCell.identifier
        )
        self.view = registrationView
        //setViewGesture()
    }
    
    func setupNavigationBar() {
        let button = UIBarButtonItem(title: "Done",
                                     style: .plain,
                                     target: self,
                                     action: #selector(registerProduct))
        
        navigationItem.title = "상품등록"
        navigationItem.rightBarButtonItem  = button
    }
    
    @objc func registerProduct() {
    }
    
//    private func setViewGesture() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDownAction))
//        view.addGestureRecognizer(tapGesture)
//    }
//
//    @objc func keyboardDownAction(_ sender: UISwipeGestureRecognizer) {
//        self.view.endEditing(true)
//    }
}

extension RegistrationViewController: UICollectionViewDelegate,
                                      UICollectionViewDataSource,
                                      UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return registrationView.selectedImage.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCollectionViewCell.identifier,
            for: indexPath
        ) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        switch indexPath.item {
        case registrationView.selectedImage.count:
            cell.setUpPlusImage()
        default:
            var image = registrationView.selectedImage[indexPath.item]
            
            if let data = image.jpegData(compressionQuality: 1),
               Double(NSData(data: data).count) / 1000.0 > 300 {
                image = image.resize()
            }
            
            cell.setUpImage(image: image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height * 0.8,
                      height: collectionView.frame.height * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item == registrationView.selectedImage.count else { return }
            showImagePicker()
    }
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard registrationView.selectedImage.count < 5 else {
            dismiss(animated: true)
            return
        }
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        registrationView.selectedImage.append(image)
        dismiss(animated: true)
        registrationView.imageCollectionView.reloadData()
    }
}
