//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/24.
//

import UIKit

final class RegisterViewController: UIViewController {
    private lazy var editView = EditView(frame: view.frame)
    private let viewModel = RegisterViewModel()
    let imagePicker = UIImagePickerController()
    
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
    
    private func setUpKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        if validateInput() {
            viewModel.requestPost(makeProductsPost())
        }
        self.dismiss(animated: true)
    }
    
    private func validateInput() -> Bool {
        guard editView.productNameTextField.text?.count ?? 0 >= 3 else {
            print("3글자 이상 입력해 주세요")
            return false
        }
        
        guard let productPrice = Int(editView.productPriceTextField.text ?? "0") else {
            print("상품가격을 입력하세요.")
            return false
        }

        guard let discountedPrice = Int(editView.productDiscountedTextField.text ?? "0"),
                productPrice >= discountedPrice else {
            print("할인금액이 더 클수는 없어")
            return false
        }
        
        guard viewModel.images.count >= 2 else {
            print("1개 이상의 사진이 필요합니다")
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
        viewModel.images.removeLast()
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

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        return nil
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
        print("")
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
