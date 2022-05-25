//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/23.
//

import UIKit

final class RegisterViewController: UIViewController, UIImagePickerControllerDelegate {
    lazy var productView = ProductView(frame: view.frame)
    weak var delegate: ListUpdatable?
    private var currency: Currency = .KRW
    private var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = productView

        setUpNavigationBar()
        defineCollectionViewDelegate()
        defineTextFieldDelegate()
        
        setUpInitialCurrencyState()
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
    
    private func setUpNavigationBar() {
        self.navigationItem.title = "상품등록"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(requestRegistration))
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.hidesBackButton = true
        let backbutton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelRegistration))
        backbutton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.preferredFont(for: .body, weight: .semibold)], for: .normal)
        self.navigationItem.leftBarButtonItem = backbutton
    }
    
    private func setUpInitialCurrencyState() {
        productView.currencyField.addTarget(self, action: #selector(changeCurrency(_:)), for: .valueChanged)
        productView.currencyField.selectedSegmentIndex = 0
        self.changeCurrency(productView.currencyField)
    }
    
    @objc func changeCurrency(_ sender: UISegmentedControl) {
        let mode = sender.selectedSegmentIndex
        if mode == Currency.KRW.value {
            currency = Currency.KRW
        } else if mode == Currency.USD.value {
            currency = Currency.USD
        }
    }
    
    @objc private func cancelRegistration(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func requestRegistration(_ sender: UIBarButtonItem) {
        guard let data = makeRegisterPostBody() else {
            return
        }
        RequestAssistant.shared.requestRegisterAPI(body: data) { _ in
            self.delegate?.refreshProductList()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func makeRegisterPostBody() -> Data? {
        guard let name = productView.nameField.text, productView.validTextField(productView.nameField) else {
            let alert = UIAlertController(title: "상품명을 3자 이상 100자 이하로 입력해주세요.", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "닫기", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
            return nil
        }
        guard productView.validTextView(productView.descriptionView) else {
            let alert = UIAlertController(title: "상품 설명을 10자 이상 1000자 이하로 입력해주세요.", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "닫기", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
            return nil
        }
        guard let price = Double(productView.priceField.text ?? "0.0") else {
            return nil
        }
        guard let discountedPrice = Double(productView.discountedPriceField.text ?? "0.0") else {
            return nil
        }
        guard let stock = Int(productView.stockField.text ?? "0") else {
            return nil
        }
        
        if images.count == 0 {
            let alert = UIAlertController(title: "이미지를 하나 이상 추가해주세요.", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "닫기", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let maxKBSize: Double = 300.0
        guard let editedImage = info[.editedImage] as? UIImage else {
            return
        }
        let image = resizeImageToFit(editedImage, at: maxKBSize)
        
        images.append(image)
        dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            self.productView.collectionView.reloadData()
        }
    }
    
    private func resizeImageToFit(_ editedImage: UIImage, at maxSize: Double) -> UIImage {
        var image = editedImage
        guard let imagaDataSize = image.jpegData(compressionQuality: 1.0)?.count else {
            return image
        }
        var imageSize: Double = Double(imagaDataSize) / 1024
        
        guard let cellSize = productView.collectionView.visibleCells.first?.frame.size else {
            return image
        }
        if imageSize > maxSize {
            image = image.resize(target: cellSize)
            if let imagaDataSize = image.jpegData(compressionQuality: 1.0)?.count {
                imageSize = Double(imagaDataSize) / 1024
            }
        }
        
        while imageSize > maxSize {
            let ratio = (imageSize / maxSize)
            if ratio > 2 {
                image = image.resize(ratio: ratio)
            } else {
                image = image.resize(ratio: 2.0)
            }
            if let imagaDataSize = image.jpegData(compressionQuality: 1.0)?.count {
                imageSize = Double(imagaDataSize) / 1024
            }
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

extension RegisterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.keyboardType == .numberPad {
            if CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) {
                return true
            }
        }
        return false
    }
}

extension RegisterViewController {
    private func defineCollectionViewDelegate() {
        productView.collectionView.delegate = self
        productView.collectionView.dataSource = self
    }
    
    private func defineTextFieldDelegate() {
        productView.priceField.delegate = self
        productView.discountedPriceField.delegate = self
        productView.stockField.delegate = self
    }
}
