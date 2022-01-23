import UIKit

class ProductRegisterViewController: UIViewController {
    private enum Task {
        case register, modify
    }

    private var taskType: Task = .modify
    private var productIdentification: Int?
    private let productService = ProductService()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    private let stackView = ProductRegisterView()
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()

    private lazy var imageActionSheet: UIAlertController = {
        let actionSheet = UIAlertController(
            title: "사진 등록",
            message: nil,
            preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let albumAction = UIAlertAction(title: "앨범", style: .default) { [weak self] _ in
            self?.presentAlbum()
        }
        let cameraAction = UIAlertAction(title: "카메라", style: .default) { _ in
            self.presentCamera()
        }
        actionSheet.addAction(albumAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancelAction)
        return actionSheet
    }()

    private let imageCapacityAlert: UIAlertController = {
        let alert = UIAlertController(title: "이미지를 추가할 수 없습니다.",
                                      message: "이미지는 최대 5개만 추가 가능합니다.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        return alert
    }()

    init(productIdentification: Int?) {
        self.productIdentification = productIdentification
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
        fetchProduct()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureHierarchy()
        setDelegate()
        configureConstraint()
        configureNavigationBar()
    }
}

// MARK: Networking
extension ProductRegisterViewController {
    func fetchProduct() {
        guard let productIdentification = self.productIdentification else {
            taskType = .register
            return
        }
        productService.retrieveProduct(
            productIdentification: productIdentification,
            session: HTTPUtility.defaultSession) { result in
                switch result {
                case .success(let product):
                    DispatchQueue.main.async {
                        self.configureContent(product: product)
                    }
                case .failure:
                    return
                }
            }
    }

//    func registerProduct() {
//        let registerProductRequest = RegisterProductRequest(
//            name: stackView.nameTextField.text!,
//            descriptions: stackView.descriptionTextView.text,
//            price: Decimal(string: stackView.priceTextField.text!, locale: nil)!,
//            currency: Currency.KRW,
//            discountedPrice: Decimal(string: stackView.discountTextField.text!, locale: nil),
//            stock: Int(stackView.stockTextField.text!)!,
//            secret: UserDefaultUtility().getVendorPassword()!
//        )
//        stackView.imageList.remove(at: 0)
//        let imageData = stackView.imageList.map {
//            $0.jpegData(compressionQuality: 1)!
//        }
//
//        productService.registerProduct(
//            parameters: registerProductRequest,
//            session: HTTPUtility.defaultSession,
//            images: imageData) { result in
//                switch result {
//                case .success(let product):
//                    print(product)
//                case .failure:
//                    print("실패")
//                    return
//                }
//            }
//    }
}

// MARK: Navigation Bar Configuration
extension ProductRegisterViewController {
    private func configureNavigationBar() {
        switch taskType {
        case .register:
            self.navigationItem.title = "상품등록"
        case .modify:
            self.navigationItem.title = "상품수정"
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(touchUpDoneButton))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(touchUpCancelButton))
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    @objc func touchUpDoneButton() {
        //registerProduct()
        self.dismiss(animated: true, completion: nil)
    }

    @objc func touchUpCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Stack View Configuration
extension ProductRegisterViewController {
    func configureHierarchy() {
        scrollView.addSubview(stackView)
        self.view.addSubview(scrollView)
    }

    private func setDelegate() {
        stackView.setTextViewDelegate(delegate: self)
        stackView.setTextFieldDelegate(delegate: self)
        stackView.setCollectionViewDelegate(delegate: self)
    }
}

extension ProductRegisterViewController {
    private func configureConstraint() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 30, right: 30)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
//            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -5)
        ])
    }

    private func configureContent(product: Product) {
//        stackView.nameTextField.text = product.name
//        stackView.priceTextField.text = product.price.description
//        stackView.discountTextField.text = product.discountedPrice.description
//        stackView.stockTextField.text = product.stock.description
//        stackView.descriptionTextView.text = product.description
    }
}

// MARK: Image Picker Alert

extension ProductRegisterViewController {
    private func showActionSheet() {
        present(imageActionSheet, animated: true, completion: nil)
    }

    private func showImageCapacityAlert() {
        present(imageCapacityAlert, animated: true)
    }

    private func presentAlbum() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        presentImagePicker()
    }

    private func presentCamera() {
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        presentImagePicker()
    }

    private func presentImagePicker() {
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: Image Picker Controller Delegate
extension ProductRegisterViewController: UIImagePickerControllerDelegate,
                                         UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        print(info)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {

            let data = image.jpegData(compressionQuality: 1)!
            if data.count > 1024 * 300 {
                let newImage = image.jpegData(compressionQuality: 0.5)!
                //stackView.imageList.append(UIImage(data: newImage)!)
            } else {
            //stackView.imageList.append(image)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Collection View Delegate
extension ProductRegisterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
//            if stackView.imageList.count < 6 {
//                showActionSheet()
//            } else {
//                showImageCapacityAlert()
//            }
        }
    }
}

// MARK: Text Field Delegate
extension ProductRegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Text View Delegate
extension ProductRegisterViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .systemGray
            textView.text = "상품설명을 작성해 주세요. (최대 1000글자)"
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray {
            textView.textColor = .black
            textView.text = ""
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.textStorage.length + text.count > 1000 {
            return false
        }
        return true
    }
}
