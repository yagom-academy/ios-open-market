import UIKit

class RegisterProductViewController: ManageProductViewController {
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

    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setDelegate() {
        super.setDelegate()
        stackView.setCollectionViewDelegate(delegate: self)

    }
    // MARK: Navigation Bar Configuration
    override func configureNavigationBar() {
        super.configureNavigationBar()
        self.navigationItem.title = "상품 등록"
    }

    @objc override func touchUpDoneButton() {
        //registerProduct()
        super.touchUpDoneButton()
    }

    override func configureHierarchy() {
        super.configureHierarchy()

    }

    @objc func addImage() {
        if stackView.imageList.count < 5 {
            showActionSheet()
        } else {
            showImageCapacityAlert()
        }
    }

}

// MARK: Networking
extension RegisterProductViewController {
    func registerProduct() {
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
    }
}

// MARK: Image Picker Alert

extension RegisterProductViewController {
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
extension RegisterProductViewController: UIImagePickerControllerDelegate,
                                         UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {

            let data = image.jpegData(compressionQuality: 1)!
            if data.count > 1024 * 300 {
                let newImage = image.jpegData(compressionQuality: 0.5)!
                stackView.imageList.append(UIImage(data: newImage)!)
            } else {
            stackView.imageList.append(image)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let headerView = view as? AddImageHeaderView else {
            return
        }
        headerView.addTargetToButton(selector: #selector(addImage))
    }
}
