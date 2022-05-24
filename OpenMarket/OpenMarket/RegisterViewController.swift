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
        dismiss(animated: true, completion: nil)
        
        let urlInfo = info[.originalImage] as! UIImage
        
        
        images.append(urlInfo)
        
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
}
