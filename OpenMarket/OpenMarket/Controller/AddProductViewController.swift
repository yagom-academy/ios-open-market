import UIKit

class AddProductViewController: UIViewController {
    // MARK: - Property
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!
    @IBOutlet weak var discountedPriceTextField: UITextField!
    @IBOutlet weak var productStockTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var productImageStackView: UIStackView!
    @IBOutlet weak var addImageButton: UIButton!
    
    lazy var apiManager = APIManager.shared
    let imagePicker = UIImagePickerController()
    var newProductImages: [NewProductImage] = []
    var newProductInformation: NewProductInformation?
    var isButtonTapped = true
    var selectedIndex = 0
    
    // MARK: - Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        navigationController?.navigationBar.topItem?.title = "상품등록"
        setupDescriptionTextView()
    }
    
    // MARK: - IBAction Method
    @IBAction func tapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func tapAddImageButton(_ sender: UIButton) {
        isButtonTapped = true
        showSelectImageAlert()
    }
    
    @IBAction func tapProductImage(_ sender: UIButton) {
        isButtonTapped = false
        selectedIndex = sender.tag
        showSelectImageAlert()
    }
    
    @IBAction func tapDoneButton(_ sender: UIBarButtonItem) {
        createNewProduct()
        addToProductImages()
        guard let information = newProductInformation else { return }
        apiManager.addProduct(information: information, images: newProductImages) { result in
            switch result {
            case .success(let data):
                print("\(data.name) post 성공")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        newProductInformation = nil
    }
    
    // MARK: - Create Data To Post
    func addToProductImages() {
        let lastTagNumber = productImageStackView.subviews.count - 1
        guard lastTagNumber >= 1 else { return }
        
        for buttonTag in 1...lastTagNumber {
            getProductImageFromButton(with: buttonTag)
        }
    }
    
    func getProductImageFromButton(with tag: Int) {
        guard let imageButton = view.viewWithTag(tag) as? UIButton,
              let image = imageButton.imageView?.image,
              let imageData = image.jpegData(compressionQuality: 0.1) else { return }

        let productImage = NewProductImage(image: imageData)
        newProductImages.append(productImage)
    }
    
    func createNewProduct() {
        guard let name = productNameTextField.text,
              let priceText = productPriceTextField.text,
              let description = descriptionTextView.text else { return }
        guard let price = Double(priceText) else { return }
        let discountPriceText = discountedPriceTextField.text ?? "0.0"
        guard let discountPrice = Double(discountPriceText) else { return }
        let stockText = productStockTextField.text ?? "0"
        guard let stock = Int(stockText) else { return }
        
        var currency = Currency.KRW
        let selectedIndex = currencySegmentedControl.selectedSegmentIndex
        guard let currentTitle = currencySegmentedControl.titleForSegment(at: selectedIndex) else { return }
        if currentTitle == Currency.KRW.unit {
            currency = Currency.KRW
        } else if currentTitle == Currency.USD.unit {
            currency = Currency.USD
        }
        
        newProductInformation = NewProductInformation(name: name, descriptions: description, price: price, discountedPrice: discountPrice, currency: currency, stock: stock)
    }
}

extension AddProductViewController {
    // MARK: - Image Picker Alert Method
    func showSelectImageAlert() {
        let alert = createSelectImageAlert()
        present(alert, animated: true, completion: nil)
    }
    
    func createSelectImageAlert() -> UIAlertController {
        let alert = UIAlertController(title: "상품사진 선택", message: nil, preferredStyle: .actionSheet)
        let photoLibrary = UIAlertAction(title: "사진앨범", style: .default) { action in
            self.openPhotoLibrary()
        }
        let camera = UIAlertAction(title: "카메라", style: .default) { action in
            self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(photoLibrary)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        return alert
    }
    
    func openPhotoLibrary() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: false, completion: nil)
    }
    
    func openCamera() {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: false, completion: nil)
    }
}

extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Image Picker Delegate Method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as? UIImage {
            editProductImageStackView(with: image)
        } else if let image = info[.originalImage] as? UIImage {
            editProductImageStackView(with: image)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func editProductImageStackView(with image: UIImage) {
        guard isButtonTapped else {
            changeProductImage(with: image)
            return
        }
        addProductImage(with: image)
        if productImageStackView.subviews.count == 6 {
            addImageButton.isHidden = true
        }
    }
    
    func changeProductImage(with image: UIImage) {
        guard let selectedImage = productImageStackView.subviews[selectedIndex] as? UIButton else { return }
        selectedImage.setImage(image, for: .normal)
    }
    
    func addProductImage(with image: UIImage) {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tag = productImageStackView.subviews.count
        let lastSubviewIndex = self.productImageStackView.subviews.count - 1
        productImageStackView.insertArrangedSubview(button, at: lastSubviewIndex)
        button.addTarget(self, action: #selector(tapProductImage), for: .touchUpInside)
        button.heightAnchor.constraint(equalTo: productImageStackView.heightAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
    }
}
extension AddProductViewController {
    // MARK: - Text View Setup Method
    func setupDescriptionTextView() {
        setTextViewPlaceHolder()
        setTextViewOutLine()
    }
    
    func setTextViewOutLine() {
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.systemGray4.cgColor
        descriptionTextView.layer.cornerRadius = 5
    }
    
    func setTextViewPlaceHolder() {
        descriptionTextView.delegate = self
        descriptionTextView.text = "상품 설명(1,000자 이내)"
        descriptionTextView.textColor = .lightGray
    }
}

extension AddProductViewController: UITextViewDelegate {
    // MARK: - Text View Delegate Method
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let cunrrentText = descriptionTextView.text else { return true }
        let newLength = cunrrentText.count + text.count - range.length
        return newLength <= 1000
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
        
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "상품 설명(1,000자 이내)"
            textView.textColor = UIColor.lightGray
        }
    }
}
