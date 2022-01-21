import UIKit

class ProductRegisterViewController: UIViewController {
    private enum Task {
        case register, modify
    }

    private var taskType: Task = .modify
    private var productIdentification: Int?
    private let productService = ProductService()
    private lazy var stackView: ProductRegisterView = {
        let view = ProductRegisterView()
        return view
    }()

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
        self.view.addSubview(stackView)
        stackView.imageCollectionView.delegate = self
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

    func registerProduct() {
        let registerProductRequest = RegisterProductRequest(
            name: stackView.nameTextField.text!,
            descriptions: stackView.descriptionTextView.text,
            price: Int(stackView.priceTextField.text!)!,
            currency: Currency.KRW,
            secret: UserDefaultUtility().getVendorPassword()!)
        let imageData = stackView.imageList.map {
            $0.pngData()!
        }

        productService.registerProduct(
            parameters: registerProductRequest,
            session: HTTPUtility.defaultSession,
            images: imageData) { result in
                switch result {
                case .success(let product):
                    print(product)
                case .failure:
                    print("실패")
                    return
                }
            }
    }
}

// MARK: Navigation Bar Configuration
extension ProductRegisterViewController {
    private func configureNavigationBar() {
        switch taskType {
        case .register:
            self.navigationItem.title = "상품등록"
        case .modify:
            self.navigationItem.title = "상품취소"
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(touchUpDoneButton))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(touchUpCancelButton))
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    @objc func touchUpDoneButton() {
        registerProduct()
        self.dismiss(animated: true, completion: nil)
    }

    @objc func touchUpCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Stack View Configuration
extension ProductRegisterViewController {
    private func configureConstraint() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
    }

    private func configureContent(product: Product) {
        stackView.nameTextField.text = product.name
        stackView.priceTextField.text = product.price.description
        stackView.discountTextField.text = product.discountedPrice.description
        stackView.stockTextField.text = product.stock.description
        stackView.descriptionTextView.text = product.description
    }
}

// MARK: Image Picker Alert

extension ProductRegisterViewController {
    private func showActionSheet() {
        present(imageActionSheet, animated: true, completion: nil)
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
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            stackView.imageList.insert(image, at: 0)
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Collection View Delegate
extension ProductRegisterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == stackView.imageList.count - 1 {
            showActionSheet()
        }
    }
}
