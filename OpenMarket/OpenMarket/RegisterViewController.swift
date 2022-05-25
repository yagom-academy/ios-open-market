//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/23.
//

import UIKit

final class RegisterViewController: UIViewController, UIImagePickerControllerDelegate {
    lazy var productView = ProductView(frame: view.frame)
    
    var currency: Currency = .KRW
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = productView
        productView.collectionView.delegate = self
        productView.collectionView.dataSource = self
        
        self.navigationItem.title = "상품등록"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneToMain))
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.hidesBackButton = true
        let backbutton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backToMain))
        backbutton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.preferredFont(for: .body, weight: .semibold)], for: .normal)
        self.navigationItem.leftBarButtonItem = backbutton
        
        productView.currencyField.addTarget(self, action: #selector(changeCurrency(_:)), for: .valueChanged)
        productView.currencyField.selectedSegmentIndex = 0
        self.changeCurrency(productView.currencyField)
        
        
        
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
}

extension RegisterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width * 0.4, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imageNumber = images.count + 1
        return imageNumber <= 5 ? imageNumber : 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageRegisterCell else {
            return ImageRegisterCell()
        }
        if indexPath.row < images.count {
            cell.imageView.image = images[indexPath.row]
            cell.plusButton.isHidden = true
            cell.imageView.backgroundColor = .clear
        } else {
            cell.plusButton.addTarget(self, action: #selector(actionSheetAlert), for: .touchUpInside)
        }
        return cell
    }
}

extension RegisterViewController: UINavigationControllerDelegate, UIPickerViewDelegate {
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        vc.cameraFlashMode = .on
        
        present(vc, animated: true, completion: nil)
    }
    
    func presentAlbum() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        
        present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let maxKBSize: Double = 300.0
        guard let editedImage = info[.editedImage] as? UIImage else {
            return
        }
        var image = editedImage
        guard let imagaDataSize = image.jpegData(compressionQuality: 1.0)?.count else {
            return
        }
        var imageSize: Double = Double(imagaDataSize) / 1024
        
        
        guard let cellSize = productView.collectionView.visibleCells.first?.frame.size else {
            return
        }
        print("# Size of image in KB: \(imageSize) KB")
        if imageSize > maxKBSize {
            print("# ============================================")
            image = image.resize(target: cellSize)
            guard let imagaDataSize = image.jpegData(compressionQuality: 1.0)?.count else {
                return
            }
            imageSize = Double(imagaDataSize) / 1024
            print("# Size of image in KB: \(imageSize) KB")
        }
        
        while imageSize > maxKBSize {
            let ratio = (imageSize / maxKBSize)
            if ratio > 2 {
                image = image.resize(ratio: ratio)
            } else {
                image = image.resize(ratio: 2.0)
            }
            guard let imagaDataSize = image.jpegData(compressionQuality: 1.0)?.count else {
                return
            }
            imageSize = Double(imagaDataSize) / 1024
            print("# Size of image in KB: \(imageSize) KB")
        }
        
        images.append(image)
        dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            self.productView.collectionView.reloadData()
        }
        
    }
    
    @objc func actionSheetAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let camera = UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
            self?.presentCamera()
        }
        let album = UIAlertAction(title: "앨범", style: .default) { [weak self] _ in
            self?.presentAlbum()
        }
        
        alert.addAction(cancel)
        alert.addAction(camera)
        alert.addAction(album)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func backToMain(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneToMain(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        
        // Post
        
        // delegate
    }
    
    @objc func changeCurrency(_ sender: UISegmentedControl) {
        let mode = sender.selectedSegmentIndex
        if mode == Currency.KRW.value {
            currency = Currency.KRW
        } else if mode == Currency.USD.value {
            currency = Currency.USD
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.productView.mainScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            
            if self.productView.descriptionView.isFirstResponder {
                productView.mainScrollView.scrollRectToVisible(productView.descriptionView.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.productView.mainScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        productView.endEditing(true)
    }
}
