//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/24.
//

import UIKit

final class RegisterViewController: UIViewController {
    private enum Constants {
        static let requestErrorAlertTitle = "오류 발생"
        static let requestErrorAlertConfirmTitle = "메인화면으로 돌아가기"
        static let inputErrorAlertTitle = "등록 정보 오류"
        static let inputErrorAlertConfirmTitle = "확인"
    }
    
    private lazy var editView = EditView(frame: view.frame)
    private let viewModel = RegisterViewModel()
    private let imagePicker = UIImagePickerController()
    
    override func loadView() {
        super.loadView()
        view.addSubview(editView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarItems()
        setUpViewModel()
        setUpImagePicker()
        setUpKeyboardNotification()
        setUpTextView()
        setUpTextField()
        viewModel.setUpDefaultImage()
    }
    
    private func setUpBarItems() {
        editView.setUpBarItem(title: "상품등록")
        editView.navigationBarItem.leftBarButtonItem?.target = self
        editView.navigationBarItem.leftBarButtonItem?.action = #selector(didTapCancelButton)
        
        editView.navigationBarItem.rightBarButtonItem?.target = self
        editView.navigationBarItem.rightBarButtonItem?.action = #selector(didTapDoneButton)
    }
    
    private func setUpViewModel() {
        viewModel.datasource = makeDataSource()
        viewModel.delegate = self
    }
    
    private func setUpImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    private func setUpTextView() {
        editView.productDescriptionTextView.addKeyboardHideButton(target: self, selector: #selector(didTapKeyboardHideButton))
    }
    
    private func setUpTextField() {
        editView.productNameTextField.addKeyboardHideButton(target: self, selector: #selector(didTapKeyboardHideButton))
        editView.productPriceTextField.addKeyboardHideButton(target: self, selector: #selector(didTapKeyboardHideButton))
        editView.productDiscountedTextField.addKeyboardHideButton(target: self, selector: #selector(didTapKeyboardHideButton))
        editView.productStockTextField.addKeyboardHideButton(target: self, selector: #selector(didTapKeyboardHideButton))
    }
    
    private func setUpKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func didTapKeyboardHideButton() {
        editView.productDescriptionTextView.resignFirstResponder()
        editView.productNameTextField.resignFirstResponder()
        editView.productPriceTextField.resignFirstResponder()
        editView.productDiscountedTextField.resignFirstResponder()
        editView.productStockTextField.resignFirstResponder()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        editView.topScrollView.contentInset.bottom = keyboardFrame.size.height
        
        let firstResponder = editView.firstResponder
        
        if let textView = firstResponder as? UITextView {
            editView.topScrollView.scrollRectToVisible(textView.frame, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        editView.topScrollView.contentInset = contentInset
        editView.topScrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func didTapCancelButton() {
        self.dismiss(animated: true)
    }
    
    @objc private func didTapDoneButton() {
        if checkInputValidation() {
            viewModel.removeLastImage()
            viewModel.requestPost(makeProductsPost())
            self.dismiss(animated: true)
        }
    }
    
    private func checkInputValidation() -> Bool {
        guard editView.productNameTextField.text?.count ?? 0 >= 3 else {
            showAlertInputError(with: .productNameIsTooShort)
            return false
        }
        
        guard let productPrice = Int(editView.productPriceTextField.text ?? "0") else {
            showAlertInputError(with: .productPriceIsEmpty)
            return false
        }

        let discountedPrice = Int(editView.productDiscountedTextField.text ?? "0") ?? 0
        
        guard productPrice >= discountedPrice else {
            showAlertInputError(with: .discountedPriceHigherThanPrice)
            return false
        }
        
        guard viewModel.images.count >= 2 else {
            showAlertInputError(with: .productImageIsEmpty)
            return false
        }
        
        return true
    }
    
    private func makeProductsPost() -> ProductsPost {
        let productName = editView.productNameTextField.text ?? ""
        let descriptions = editView.productDescriptionTextView.text ?? ""
        let productPrice = Double(editView.productPriceTextField.text ?? "0") ?? 0
        let currency = editView.productCurrencySegmentedControl.selectedSegmentIndex == 0 ? "KRW" : "USD"
        let discountedPrice = Double(editView.productDiscountedTextField.text ?? "0")
        let stock = Int(editView.productStockTextField.text ?? "0")
        let secret = "password"
        let images = viewModel.images
        
        return ProductsPost(name: productName,
                     descriptions: descriptions,
                     price: productPrice,
                     currency: currency,
                     discountedPrice: discountedPrice,
                     stock: stock,
                     secret: secret,
                     image: images)
    }
}

extension RegisterViewController {
    private func makeDataSource() -> UICollectionViewDiffableDataSource<RegisterViewModel.Section, ImageInfo> {
        let dataSource = UICollectionViewDiffableDataSource<RegisterViewModel.Section, ImageInfo>(
            collectionView: editView.collectionView,
            cellProvider: { (collectionView, indexPath, image) -> UICollectionViewCell in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProductsHorizontalCell.identifier,
                    for: indexPath) as? ProductsHorizontalCell else {
                    return UICollectionViewCell()
                }
                
                cell.updateImage(imageInfo: image)
                cell.delegate = self

                return cell
            })
        return dataSource
    }
}

extension RegisterViewController: AlertDelegate {
    func showAlertRequestError(with error: Error) {
        self.alertBuilder
            .setTitle(Constants.requestErrorAlertTitle)
            .setMessage(error.localizedDescription)
            .setConfirmTitle(Constants.requestErrorAlertConfirmTitle)
            .setConfirmHandler {
                self.dismiss(animated: true)
            }
            .showAlert()
    }
    
    private func showAlertInputError(with error: InputError) {
        self.alertBuilder
            .setTitle(Constants.inputErrorAlertTitle)
            .setMessage(error.localizedDescription)
            .setConfirmTitle(Constants.inputErrorAlertConfirmTitle)
            .showAlert()
    }
}

extension RegisterViewController: CellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func addButtonTaped() {
        if viewModel.images.count < 6 {
            self.present(imagePicker, animated: true)
        } else {
            print("사진은 5장까지")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let captureImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        viewModel.insert(image: captureImage)
        self.dismiss(animated: true, completion: nil)
    }
}
