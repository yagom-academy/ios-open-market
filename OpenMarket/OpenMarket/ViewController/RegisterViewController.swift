//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/23.
//

import UIKit

extension API {
    static let maxSize: Double = 300.0
    static let maxImageNumber: Int = 5
}

final class RegisterViewController: ProductViewController {
    private var images: [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        defineCollectionViewDelegate()
    }
    
    override func setUpNavigationBar() {
        super.setUpNavigationBar()
        self.navigationItem.title = "상품등록"
        let requestButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(requestRegistration))
        self.navigationItem.rightBarButtonItem = requestButton
    }
    
    @objc private func requestRegistration(_ sender: UIBarButtonItem) {
        guard let data = makeRequestBody() else {
            return
        }
        RequestAssistant.shared.requestRegisterAPI(body: data) { _ in
            self.delegate?.refreshProductList()
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    private func makeRequestBody() -> Data? {
        guard let name = productView.nameField.text, productView.validTextField(productView.nameField) else {
            showAlert(alertTitle: "상품명을 3자 이상 100자 이하로 입력해주세요.")
            return nil
        }
        guard productView.validTextView(productView.descriptionView) else {
            showAlert(alertTitle: "상품 설명을 10자 이상 1000자 이하로 입력해주세요.")
            return nil
        }
        guard let price = Double(productView.priceField.text ?? "0.0") else {
            return nil
        }
        let discountedPrice = Double(productView.discountedPriceField.text ?? "0.0")
        
        let stock = Int(productView.stockField.text ?? "0")
        
        if images.count == 0 {
            showAlert(alertTitle: "이미지를 하나 이상 추가해주세요.")
            return nil
        }
        
        var data = Data()
        let productToRegister = ProductToRegister(name: name, currency: currency, price: price, descriptions: self.productView.descriptionView.text, discountedPrice: discountedPrice, stock: stock)
        data.append(appendParams(productToRegister))
        images.forEach {
            data.append(appendImage($0))
        }
        
        guard let endOfMultipartFormData = "--\(API.boundary)--\r\n".data(using: .utf8) else {
            return nil
        }
        data.append(endOfMultipartFormData)
        
        return data
    }
    
    private func appendParams(_ registerProduct: ProductToRegister) -> Data {
        var data = Data()
        var dataString: String = ""
        guard let params = try? JSONEncoder().encode(registerProduct) else {
            return data
        }
        dataString.append("--\(API.boundary)\r\n")
        dataString.append("Content-Disposition: form-data; name=\"params\"\r\n")
        dataString.append("Content-Type: application/json\r\n")
        dataString.append("\r\n")
        guard let headData = dataString.data(using: .utf8) else {
            return data
        }
        guard let tailData = "\r\n".data(using: .utf8) else {
            return data
        }
        data.append(headData)
        data.append(params)
        data.append(tailData)
        
        return data
    }
    
    func appendImage(_ image: UIImage) -> Data {
        var data = Data()
        var dataString: String = ""
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return data
        }
        dataString.append("--\(API.boundary)\r\n")
        dataString.append("Content-Disposition: form-data; name=\"images\"; filename=\"image.jpg\"\r\n")
        dataString.append("Content-Type: jpg\r\n")
        dataString.append("\r\n")
        guard let headData = dataString.data(using: .utf8) else {
            return data
        }
        guard let tailData = "\r\n".data(using: .utf8) else {
            return data
        }
        data.append(headData)
        data.append(imageData)
        data.append(tailData)
        
        return data
    }
    
    private func defineCollectionViewDelegate() {
        productView.collectionView.delegate = self
        productView.collectionView.dataSource = self
    }
}

extension RegisterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width * 0.4, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imageNumber = images.count + 1
        
        return imageNumber <= API.maxImageNumber ? imageNumber : API.maxImageNumber
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

extension RegisterViewController: UINavigationControllerDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let editedImage = info[.editedImage] as? UIImage else {
            return
        }
        let image = resizeImageToFit(editedImage, at: API.maxSize)
        
        images.append(image)
        dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            self.productView.collectionView.reloadData()
        }
    }
    
    private func resizeImageToFit(_ editedImage: UIImage, at maxSize: Double) -> UIImage {
        var image = editedImage
        var imageSize = image.size()
        while imageSize > maxSize {
            let ratio = (imageSize / maxSize)
            image = image.resize(ratio: ratio)
            if image.size() > imageSize {
                image = image.compress(ratio: ratio)
            }
            imageSize = image.size()
        }
        return image
    }
    
    @objc private func actionSheetAlert() {
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
    
    private func presentCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        picker.cameraFlashMode = .on
        
        present(picker, animated: true, completion: nil)
    }
    
    private func presentAlbum() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
}
