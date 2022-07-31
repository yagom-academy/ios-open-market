import UIKit

class ProductsDetailViewController: UIViewController {

    let imagePicker = UIImagePickerController()
    let imageChangePicker = UIImagePickerController()
    
    var selectedImageView: UIImageView?
    
    // MARK: - Life Cycle

    override func loadView() {
        view = ProductDetailView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        configureImagePicker()
        
        guard let detailView = view as? ProductDetailView else { return }
        
        detailView.configureDelegate(viewController: self)
        
        addNavigationBarButton()
       
        addTargetAction()
        
        makeNotification()
    }
    
    func makeNotification() {
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
        guard let detailView = view as? ProductDetailView else { return }

        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
        }
        
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0)
        detailView.mainScrollView.contentInset = contentInset
        detailView.mainScrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide() {
        guard let detailView = view as? ProductDetailView else { return }

        let contentInset = UIEdgeInsets.zero
        detailView.mainScrollView.contentInset = contentInset
        detailView.mainScrollView.scrollIndicatorInsets = contentInset
    }

    
    private func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "상품등록"
    }
    
    private func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        imageChangePicker.delegate = self
        imageChangePicker.allowsEditing = true
        imageChangePicker.sourceType = .photoLibrary
    }
    
    private func addTargetAction() {
        guard let detailView = view as? ProductDetailView else { return }
        detailView.rightBarPlusButton.addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        detailView.mainScrollView.addGestureRecognizer(tap)
        
        navigationItem.rightBarButtonItem?.action = #selector(doneButtonDidTapped)
    }
    
    private func addNavigationBarButton() {
        navigationController?.navigationBar.topItem?.title = "Cancel"
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
    }
}

// MARK: - UIImagePicker & UINavigation ControllerDelegate Function

extension ProductsDetailViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        switch picker {
        case imagePicker:
            guard let detailView = view as? ProductDetailView else { return }
            guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
            
            detailView.addToScrollView(of: selectedImage, viewController: self)
            
            let imageStackViewCount = detailView.imageStackView.arrangedSubviews.count - 2
            let firstImageView = detailView.imageStackView.arrangedSubviews[imageStackViewCount]
            let tap = UITapGestureRecognizer(target: self, action: #selector(changeImageButtonTapped))
            firstImageView.addGestureRecognizer(tap)
            
            if detailView.imageStackView.arrangedSubviews.count == 6 {
                detailView.rightBarPlusButton.removeFromSuperview()
            }
        case imageChangePicker:
            guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
            selectedImageView?.image = selectedImage
        default:
            break
        }
        dismiss(animated: true)
    }
}

// MARK: - @objc Functions

extension ProductsDetailViewController {
    @objc private func doneButtonDidTapped() {
        guard let detailView = view as? ProductDetailView else { return }
        
        var imageViews = detailView.imageStackView.arrangedSubviews
        
        guard let productName = detailView.itemNameTextField.text,
              let productPrice = Int(detailView.itemPriceTextField.text ?? "0"),
              let productSale = Int(detailView.itemSaleTextField.text ?? "0"),
              let productStock = Int(detailView.itemStockTextField.text ?? "0"),
              let productDesciprtion = detailView.descriptionTextView.text,
              let productCurrency = Currency(rawValue: detailView.currencySegmentControl.selectedSegmentIndex) else { return }
        
        if imageViews.last is UIButton {
            imageViews.removeLast()
        }
        
        var images: [UIImage] = []
        imageViews.forEach {
            guard let imageView = $0 as? UIImageView,
                  let image = imageView.image else { return }
            images.append(image)
        }
        
        let parameter = Parameters(name: productName, descriptions: productDesciprtion, price: productPrice, currency: productCurrency, secret: UserInfo.secret.rawValue, discountedPrice: productSale, stock: productStock)
        
        ProductsDataManager.shared.postData(identifier: UserInfo.identifier.rawValue, paramter: parameter, images: images) { (data: PostResponse) in
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
        
        present(imageChangePicker, animated: true)
    }
}

// MARK: - UITextFieldDelegate Functions

extension ProductsDetailViewController: UITextFieldDelegate {
    private func textFieldshouldBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: - UITextViewDelegate Functions

extension ProductsDetailViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
//        guard let detailView = view as? ProductDetailView else { return }
//        guard let textSelectedTextRange = textView.selectedTextRange else { return }
//        let caret = textView.caretRect(for: textSelectedTextRange.start)
//        let scrollPoint = CGPoint(x: 0, y: caret.origin.y - 50)
//        
//        if scrollPoint.y != .infinity && scrollPoint.y > 0.0 {
//            detailView.mainScrollView.setContentOffset(scrollPoint, animated: true)
//        }
    }
}
