import UIKit

class ProductsRegistViewController: UIViewController {
    
    let imagePicker = UIImagePickerController()
    var selectedImageView: UIImageView?
    
    var registView = ProductRegistView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = registView
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureImagePicker()
        registView.configureDelegate(viewController: self)
        addNavigationBarButton()
        addTargetAction()
        makeNotification()
    }
    
    private func presentAlertMessage(message: String) {
        let alert = UIAlertController(title: "에러!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func makeNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0)
        registView.mainScrollView.contentInset = contentInset
        registView.mainScrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        registView.mainScrollView.contentInset = contentInset
        registView.mainScrollView.scrollIndicatorInsets = contentInset
    }
    
    private func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
//        title = "상품등록"
    }
    
    private func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    }
    
    private func addTargetAction() {
        registView.addImageButton.addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        registView.mainScrollView.addGestureRecognizer(tap)
        
        navigationItem.rightBarButtonItem?.action = #selector(doneButtonDidTapped)
    }
    
    private func addNavigationBarButton() {
        navigationController?.navigationBar.topItem?.title = "Cancel"
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
    }
    
    private func checkPostCondition() -> Bool {
        if registView.imageStackView.arrangedSubviews.count <= 1 {
            presentAlertMessage(message: "이미지를 추가해주세요.")
            return false
        } else if registView.itemNameTextField.text?.count ?? 0 < 3 {
            presentAlertMessage(message: "상품명을 세 글자 이상 작성해주세요.")
            return false
        } else if registView.itemPriceTextField.text?.isEmpty ?? true {
            presentAlertMessage(message: "상품가격을 입력하세요.")
            return false
        } else if registView.descriptionTextView.text.isEmpty {
            presentAlertMessage(message: "상품설명을 입력하세요.")
            return false
        } else if registView.descriptionTextView.text.count < 10 {
            presentAlertMessage(message: "상품설명을 10자 이상 작성해주세요.")
            return false
        }
        return true
    }
}

// MARK: - UIImagePicker & UINavigation ControllerDelegate Function

extension ProductsRegistViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        if let selectedImageView = selectedImageView {
            
            selectedImageView.image = selectedImage
            self.selectedImageView = nil
        } else {
            registView.addToScrollView(of: selectedImage, viewController: self)
            
            let imageStackViewCount = registView.imageStackView.arrangedSubviews.count - 2
            let firstImageView = registView.imageStackView.arrangedSubviews[imageStackViewCount]
            let tap = UITapGestureRecognizer(target: self, action: #selector(changeImageButtonTapped))
            firstImageView.addGestureRecognizer(tap)
            
            if registView.imageStackView.arrangedSubviews.count == 6 {
                registView.addImageButton.removeFromSuperview()
            }
        }
        dismiss(animated: true)
    }
}

// MARK: - @objc Functions

extension ProductsRegistViewController {
    @objc private func doneButtonDidTapped() {
        if checkPostCondition() == false {
            return
        }
        
        var imageViews = registView.imageStackView.arrangedSubviews
        
        guard let productName = registView.itemNameTextField.text,
              let productPrice = Int(registView.itemPriceTextField.text ?? "0"),
              let productSale = Int(registView.itemSaleTextField.text ?? "0"),
              let productStock = Int(registView.itemStockTextField.text ?? "0"),
              let productDesciprtion = registView.descriptionTextView.text,
              let productCurrency = Corrency(rawValue: registView.currencySegmentControl.selectedSegmentIndex) else { return }
        
        if imageViews.last is UIButton {
            imageViews.removeLast()
        }
        
        var images: [UIImage] = []
        imageViews.forEach {
            guard let imageView = $0 as? UIImageView,
                  let image = imageView.image else { return }
            images.append(image)
        }
        
        let parameter = Parameters(name: productName,
                                   descriptions: productDesciprtion,
                                   price: productPrice,
                                   currency: productCurrency,
                                   secret: UserInfo.secret.rawValue,
                                   discountedPrice: productSale,
                                   stock: productStock)
        
        ProductsDataManager.shared.postData(identifier: UserInfo.identifier.rawValue,
                                            paramter: parameter,
                                            images: images)
        { (data: PostResponse) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc private func endEditing() {
        view.endEditing(true)
    }
    
    @objc private func addButtonDidTapped() {
        present(imagePicker, animated: true)
    }
    
    @objc private func changeImageButtonTapped(_ sender: UITapGestureRecognizer) {
        selectedImageView = sender.view as? UIImageView
        present(imagePicker, animated: true)
    }
}

// MARK: - UITextFieldDelegate Functions

extension ProductsRegistViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isEmptySaleAndStockTextField(textField) {
            registView.itemSaleTextField.text = "0"
            registView.itemStockTextField.text = "0"
        }
        
        if defaultTextField(textField) {
            textField.text = ""
        }
    }
    
    func isEmptySaleAndStockTextField(_ textField: UITextField) -> Bool {
        guard let detailView = view as? ProductRegistView else { return false }
        
        return textField == detailView.itemNameTextField
        && detailView.itemSaleTextField.text?.isEmpty ?? false
        && detailView.itemStockTextField.text?.isEmpty ?? false
    }
    
    func defaultTextField(_ textField: UITextField) -> Bool {
        guard let detailView = view as? ProductRegistView else { return false }
        
        return (textField == detailView.itemStockTextField || textField == detailView.itemSaleTextField)
        && textField.text == "0"
    }
}

// MARK: - UITextViewDelegate Functions

extension ProductsRegistViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.cString(using: String.Encoding.utf8) == [0] {
            return true
        }
        if textView.text.count >= 1000 {
            presentAlertMessage(message: "상품설명은 1000자 이하로 입력해주세요.")
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        registView.descriptionTextViewPlaceHolder.isHidden = !registView.descriptionTextView.text.isEmpty
    }
}
