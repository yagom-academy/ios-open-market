import UIKit

class ProductsDetailViewController: UIViewController {

    let imagePicker = UIImagePickerController()
    let imageChangePicker = UIImagePickerController()
    
    var selectedImageView: UIImageView?
    
    let identifier = "d580792d-0335-11ed-9676-8179e204c0cc"
    let secret = "G3qccGq9uC"
    
    override func loadView() {
        view = ProductDetailView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "상품등록"
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        imageChangePicker.delegate = self
        imageChangePicker.allowsEditing = true
        imageChangePicker.sourceType = .photoLibrary
        
        guard let detailView = view as? ProductDetailView else { return }
        detailView.button.addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)
        
        detailView.itemNameTextField.delegate = self
        detailView.itemPriceTextField.delegate = self
        detailView.itemSaleTextField.delegate = self
        detailView.itemStockTextField.delegate = self
        
        detailView.mainScrollView.keyboardDismissMode = .interactive
        
        detailView.descriptionTextView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        detailView.mainScrollView.addGestureRecognizer(tap)
        
        addNavigationBarButton()
        
        navigationItem.rightBarButtonItem?.action = #selector(doneButtonDidTapped)
    }
    
    @objc func doneButtonDidTapped() {
        print("done 버튼 눌림")
        
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
        
        let parameter = Parameters(name: productName, descriptions: productDesciprtion, price: productPrice, currency: productCurrency, secret: self.secret, discounted_price: productSale, stock: productStock)
        
        ProductsDataManager.shared.postData(identifier: identifier, paramter: parameter, images: images) { (data: PostResponse) in
            print(data)
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    @objc func endEditing() {
        view.endEditing(true)
    }
    
    @objc func addButtonDidTapped() {
        present(imagePicker, animated: true)
    }
    
    @objc func changeImageButtonTapped(_ sender: UITapGestureRecognizer) {
        selectedImageView = sender.view as? UIImageView
        
        present(imageChangePicker, animated: true)
    }
    
    func addNavigationBarButton() {
        navigationController?.navigationBar.topItem?.title = "Cancel"
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
    }
}

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
                detailView.button.removeFromSuperview()
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

extension ProductsDetailViewController: UITextFieldDelegate {
    private func textFieldshouldBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension ProductsDetailViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let detailView = view as? ProductDetailView else { return }
        guard let textSelectedTextRange = textView.selectedTextRange else { return }
        let caret = textView.caretRect(for: textSelectedTextRange.start)
        let scrollPoint = CGPoint(x: 0, y: caret.origin.y - 50)
        
        if scrollPoint.y != .infinity && scrollPoint.y > 0.0 {
            detailView.mainScrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
}
