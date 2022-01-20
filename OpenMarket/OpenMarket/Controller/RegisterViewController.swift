//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/10.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var collectionView: ImagesCollectionView!
    @IBOutlet weak var textFieldsStackView: TextFieldsStackView!
    
    private var dataSource = RegisterDataSource(state: .register)
    var data: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpNotificationCenter()
        setUpView()
    }
    
    private func setUpView() {
        guard let product = data else {
            return
        }
        textFieldsStackView.nameTextField.text = product.name
        textFieldsStackView.priceTextField.text = product.price.description
        textFieldsStackView.currency.selectedSegmentIndex = product.currency == .krw ? 0 : 1
        textFieldsStackView.discountedPriceTextField.text = product.discountedPrice.description
        textFieldsStackView.stockTextField.text = product.stock.description
        textFieldsStackView.descriptionTextView.text = product.description ?? ""
        textFieldsStackView.descriptionTextView.textColor = .black
    }
    
    func setUpModifyMode(product: Product, images: [UIImage]) {
        data = product
        dataSource.setUpModify(images)
        self.navigationItem.title = "상품 수정"
    }
    
    private func setUpNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tappedAddButton),
            name: .addButton, object: nil
        )
    }
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = dataSource
    }
    
    private func dismissAndUpdateMain() {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .updataMain, object: nil)
        }
    }
    
    private func dismissAndUpdateDetail() {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .updateDetail, object: self.data)
            NotificationCenter.default.post(name: .updataMain, object: nil)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        guard inputValidation() else {
            return
        }
        guard let imageFiles = dataSource.createImageFiles() else {
            return
        }
        if dataSource.state == .register,
           let product = textFieldsStackView.createRegistration() {
            requestRegistration(product: product, imageFiles: imageFiles)
        } else if dataSource.state == .modify,
                  let data = data,
                  let newProduct = textFieldsStackView.createModification(data) {
            requestModification(product: newProduct)
        } else {
            self.showAlert(message: Message.productError, completion: nil)
        }
    }
    
}

extension RegisterViewController {
    private func requestModification(product: ProductModification) {
        guard let request = requestModify(params: product) else {
            showAlert(message: Message.badRequest) {
                self.dismiss(animated: true)
            }
            return
        }
        let networkManager = NetworkManager()
        networkManager.fetch(request: request, decodingType: Product.self) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.showAlert(message: Message.completeProductModification) {
                        self.dismissAndUpdateDetail()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: error.localizedDescription) {
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    private func requestRegistration(product: ProductRegistration, imageFiles: [ImageFile]) {
        guard let request = requestRegister(params: product, images: imageFiles) else {
            showAlert(message: Message.badRequest) {
                self.dismiss(animated: true)
            }
            return
        }
        let networkManager = NetworkManager()
        networkManager.fetch(request: request, decodingType: Product.self) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.showAlert(message: Message.completeProductRegistration) {
                        self.dismissAndUpdateMain()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: error.localizedDescription) {
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    private func requestRegister<T: Encodable>(params: T, images: [ImageFile]) -> URLRequest? {
        let networkManager = NetworkManager()
        let requestResult = networkManager.requestRegister(params: params, images: images)
        switch requestResult {
        case .success(let request):
            return request
        case .failure:
            return nil
        }
    }
    
    private func requestModify<T: Encodable>(params: T) -> URLRequest? {
        guard let data = data else {
            return nil
        }
        let networkManager = NetworkManager()
        let requestResult = networkManager.requestModify(data: params, id: UInt(data.id))
        switch requestResult {
        case .success(let request):
            return request
        case .failure:
            return nil
        }
    }
    
    private func inputValidation() -> Bool {
        let isValidImagesCount = dataSource.images.count > .zero
        let isValidNameCount = textFieldsStackView.nameTextField.text?.count ?? .zero >= 3
        let isValidPriceCount = (textFieldsStackView.priceTextField.text?.count ?? .zero) > .zero
        let isMaintainMiniMumDescriptionCount = textFieldsStackView.descriptionTextView.text.count >= 10
        &&  textFieldsStackView.descriptionTextView.text != Placeholder.description
        let isMaintainMaxiMumDescriptionCount = textFieldsStackView.descriptionTextView.text.count < 1000
        
        guard isValidImagesCount else {
            showAlert(message: Message.minimumImageCount)
            return false
        }
        guard isValidNameCount else {
            showAlert(message: Message.minimumNameCount)
            return false
        }
        guard isValidPriceCount else {
            showAlert(message: Message.minimumPriceCount)
            return false
        }
        guard isMaintainMiniMumDescriptionCount else {
            showAlert(message: Message.minimumDescriptionCount)
            return false
        }
        guard isMaintainMaxiMumDescriptionCount else {
            showAlert(message: Message.maximumDescriptionCount)
            return false
        }
        return true
    }
}

extension RegisterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard dataSource.state != .modify else {
            return
        }
        dataSource.imagesRemove(at: indexPath.item)
        collectionView.performBatchUpdates {
            collectionView.deleteItems(at: [IndexPath(item: indexPath.item, section: 0)])
        } completion: { _ in
            NotificationCenter.default.post(name: .editImageCountLabel, object: self.dataSource.images.count)
        }
    }
}

extension RegisterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 128, height: 128)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        guard dataSource.state != .modify else {
            return CGSize()
        }
        return CGSize(width: 128, height: 128)
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        guard let selectedImage = editedImage ?? originalImage else {
            return
        }
        dataSource.imagesAppend(selectedImage.compress())
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: [IndexPath(item: dataSource.images.count - 1, section: 0)])
        } completion: { _ in
            NotificationCenter.default.post(name: .editImageCountLabel, object: self.dataSource.images.count)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension RegisterViewController {
    @objc func tappedAddButton() {
        guard dataSource.images.count != 5 else {
            self.showAlert(message: Message.maximumImageCount)
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
}
