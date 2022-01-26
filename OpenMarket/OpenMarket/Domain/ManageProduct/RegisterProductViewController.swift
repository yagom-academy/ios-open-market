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

    private let noImageAlert: UIAlertController = {
        let alert = UIAlertController(title: "상품 이미지 등록은 필수입니다.",
                                      message: "이미지는 최소 1개 최대 5개까지 추가 가능합니다.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        return alert
    }()

    private lazy var registerSuccessAlert: UIAlertController = {
        let alert = UIAlertController(title: "상품등록에 성공하였습니다.",
                                      message: nil,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        return alert
    }()

    private let registerFailureAlert: UIAlertController = {
        let alert = UIAlertController(title: "상품등록에 실패하였습니다.",
                                      message: "잠시 뒤 다시 시도 해 주세요.",
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
        registerProduct()
    }

    override func configureHierarchy() {
        super.configureHierarchy()

    }

    @objc func addImage() {
        if self.images.count < 5 {
            showActionSheet()
        } else {
            showImageCapacityAlert()
        }
    }
}

// MARK: Networking
extension RegisterProductViewController {
    func registerProduct() {
        let form = ManageProductForm(
            name: stackView.nameTextField.text,
            price: stackView.priceTextField.text,
            currency: stackView.currencySegmentedControl.titleForSegment(
                at: stackView.currencySegmentedControl.selectedSegmentIndex),
            discountedPrice: stackView.discountTextField.text ==
                "" ? "0" : stackView.discountTextField.text,
            stock: stackView.stockTextField.text == "" ? "0" : stackView.stockTextField.text,
            descriptions: stackView.descriptionTextView.text
            )

        guard images.count > 0 else {
            self.present(noImageAlert, animated: true, completion: nil)
            return
        }

        let imagesData = images.compactMap { image in
            image.jpegData(compressionQuality: 1)
        }

        do { let result = try manageProductManger.isAppropriateToRegister(form: form)
            switch result {
            case .success(let result):
                manageProductManger.productService.registerProduct(
                    parameters: result,
                    session: HTTPUtility.defaultSession,
                    images: imagesData) { result in
                        switch result {
                        case .success:
                            DispatchQueue.main.async {
                                self.present(self.registerSuccessAlert, animated: false)
                            }
                        case .failure:
                            DispatchQueue.main.async {
                                self.present(self.registerFailureAlert, animated: true, completion: nil)
                            }
                        }
                    }

            case .failure(let inAppropriates):
                var message: String = ""
                inAppropriates.forEach { inappropriate in
                    message += inappropriate.description
                    message += " "
                }
                manageProductFormAlert.message = message
                present(manageProductFormAlert, animated: true, completion: nil)
            }
        } catch {
            return
        }
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
            let compressedImageData = manageProductManger.comperess(image: image, to: 300)
            guard let compressedImage = UIImage(data: compressedImageData) else {
                return
            }
            self.images.append(compressedImage)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterProductViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {
        guard let headerView = view as? AddImageHeaderView else {
            return
        }
        headerView.addTargetToButton(selector: #selector(addImage))
    }
}
