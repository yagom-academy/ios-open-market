//
//  ProductRegistrationViewController.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/24.
//

import UIKit

final class ProductRegistrationViewController: UIViewController {
    private let networkManager = NetworkManager()
    private let errorManager = ErrorManager()
    private let imageDataManager = ImageDataManager()
    private let productRegistrationView = ProductFormView()
    private let boundary = "Boundary-\(UUID().uuidString)"
    private let imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }()
    private var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureNavigationBar()
        configureNotification()
        
        productRegistrationView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                            action: #selector(hideKeyboard)))
        productRegistrationView.imagesCollectionView.dataSource = self
        productRegistrationView.imagesCollectionView.delegate = self
        productRegistrationView.imagesCollectionView.register(RegistrationImageCell.self,
                                                              forCellWithReuseIdentifier: RegistrationImageCell.identifier)
        imagePicker.delegate = self
    }
    
    private func configureView() {
        view = productRegistrationView
        view.backgroundColor = .white
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(cancelRegistration))
        navigationItem.title = "상품 등록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(registerProduct))
    }
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(moveUpScrollView),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(moveDownScrollView),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
}

extension ProductRegistrationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard images.count != 5 else {
            return images.count
        }
        
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: RegistrationImageCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RegistrationImageCell.identifier,
            for: indexPath) as? RegistrationImageCell
        else {
            return UICollectionViewCell()
        }
        
        guard indexPath.item != images.count else {
            cell.addButton(selector: #selector(selectImage))
            
            return cell
        }
        
        cell.addImage(images[indexPath.item])
        cell.addDeleteButton(selector: #selector(deleteImage))
        
        return cell
    }
}

extension ProductRegistrationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.bounds.width * 0.3
        let height: CGFloat = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10,
                            left: 10,
                            bottom: 10,
                            right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

extension ProductRegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            images.append(editedImage)
            productRegistrationView.imagesCollectionView.reloadData()
        }
        
        picker.dismiss(animated: true)
    }
}

extension ProductRegistrationViewController {
    @objc private func cancelRegistration() {
        dismiss(animated: true)
    }
    
    @objc private func selectImage() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func moveUpScrollView(_ notification: NSNotification) {
        if productRegistrationView.descriptionTextView.isFirstResponder,
           let userInfo = notification.userInfo,
           let value = userInfo["UIKeyboardFrameEndUserInfoKey"] as? NSValue {
            let contentOffset = CGPoint(x: 0, y: value.cgRectValue.height)
            productRegistrationView.scrollView.setContentOffset(contentOffset,
                                                                animated: true)
            productRegistrationView.scrollView.contentInset.bottom = value.cgRectValue.height
        }
    }
    
    @objc private func moveDownScrollView(_ notification: NSNotification) {
        productRegistrationView.scrollView.contentInset.bottom = 0
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
        let contentOffset = CGPoint(x: 0, y: 0)
        productRegistrationView.scrollView.setContentOffset(contentOffset,
                                                            animated: true)
    }
    
    @objc private func registerProduct() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard !images.isEmpty else {
            present(errorManager.createAlert(error: UserInputError.noImageInput), animated: true)
            navigationItem.rightBarButtonItem?.isEnabled = true
            return
        }
        
        do {
            let name = try productRegistrationView.nameInput
            let price = try productRegistrationView.priceInput
            let discount = try productRegistrationView.discountInput
            let stock = try productRegistrationView.stockInput
            let description = try productRegistrationView.descriptionInput
            
            guard price >= discount else {
                throw UserInputError.discountOverPrice
            }
            
            let product = PostProduct(name: name,
                                      description: description,
                                      price: price,
                                      currency: productRegistrationView.currencyInput,
                                      discountedPrice: discount,
                                      stock: stock,
                                      secret: "9vqf2ysxk8tnhzm9")
            
            let imageData = imageDataManager.convertImageData(images,
                                                              fileName: UUID().uuidString,
                                                              mimeType: "image/jpeg", boundary)
            
            guard let data = networkManager.configureRequestBody(product, imageData, boundary),
                  let request = networkManager.configureRequest(boundary)
            else {
                return
            }

            networkManager.postData(request: request, data: data) {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }
        } catch {
            if let error = error as? UserInputError {
                present(errorManager.createAlert(error: error), animated: true)
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
    
    @objc func deleteImage(_ button: UIButton) {
        guard let cell = button.superview?.superview as? RegistrationImageCell,
              let indexPath = productRegistrationView.imagesCollectionView.indexPath(for: cell)
        else {
            return
        }
        
        images.remove(at: indexPath.item)
        productRegistrationView.imagesCollectionView.reloadData()
    }
}
