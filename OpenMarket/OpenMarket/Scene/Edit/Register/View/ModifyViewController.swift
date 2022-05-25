//
//  ModifyViewController.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/25.
//

import UIKit

final class ModifyViewController: UIViewController {
    private enum Constants {
        static let requestErrorAlertTitle = "오류 발생"
        static let requestErrorAlertConfirmTitle = "메인화면으로 돌아가기"
        static let inputErrorAlertTitle = "등록 정보 오류"
        static let inputErrorAlertConfirmTitle = "확인"
    }
    
    private lazy var editView = EditView(frame: view.frame)
    private let viewModel = ModifyViewModel()
    private let productDetail: ProductDetail
    
    override func loadView() {
        super.loadView()
        view.addSubview(editView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpBarItems()
        setUpViewModel()
        setUpKeyboardNotification()
        setUpTextView()
        setUpTextField()
        
        print(productDetail)
    }
    
    init(productDetail: ProductDetail) {
        self.productDetail = productDetail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        editView.productNameTextField.text = productDetail.name
        editView.productPriceTextField.text = String(productDetail.price)
        editView.productDiscountedTextField.text = String(productDetail.discountedPrice)
        editView.productStockTextField.text = String(productDetail.stock)
        editView.productDescriptionTextView.text = productDetail.productsDescription
        viewModel.setUpImages(with: productDetail.images)
        
        if productDetail.currency == "KRW" {
            editView.productCurrencySegmentedControl.selectedSegmentIndex = 0
        } else {
            editView.productCurrencySegmentedControl.selectedSegmentIndex = 1
        }
    }
    
    private func setUpBarItems() {
        editView.setUpBarItem(title: "상품수정")
        editView.navigationBarItem.leftBarButtonItem?.target = self
        editView.navigationBarItem.leftBarButtonItem?.action = #selector(didTapCancelButton)
        
        editView.navigationBarItem.rightBarButtonItem?.target = self
        editView.navigationBarItem.rightBarButtonItem?.action = #selector(didTapDoneButton)
    }
    
    private func setUpViewModel() {
        viewModel.datasource = makeDataSource()
        viewModel.delegate = self
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

//MARK: extension

extension ModifyViewController {
    private func makeDataSource() -> UICollectionViewDiffableDataSource<ModifyViewModel.Section, ImageInfo> {
        let dataSource = UICollectionViewDiffableDataSource<ModifyViewModel.Section, ImageInfo>(
            collectionView: editView.collectionView,
            cellProvider: { (collectionView, indexPath, image) -> UICollectionViewCell in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProductsHorizontalCell.identifier,
                    for: indexPath) as? ProductsHorizontalCell else {
                    return UICollectionViewCell()
                }
                
                cell.updateImage(imageInfo: image)

                return cell
            })
        return dataSource
    }
}

extension ModifyViewController: EditAlertDelegate {
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
