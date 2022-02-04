import UIKit

class ItemRegistrationViewController: UIViewController {
    private let registrationView = ItemRegisterAndModifyFormView()
    private var manager = ItemRegisterAndModifyManager()
    private let imagePicker = UIImagePickerController()
    private let mode: Mode = .register

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPhotoCollectionView()
        registrationView.delegate = self
        registrationView.formViewDidLoad()
        view = registrationView
    }

    private func setupPhotoCollectionView() {
        registrationView.photoCollectionView.delegate = self
        registrationView.photoCollectionView.dataSource = self
        registrationView.photoCollectionView.register(
            ImageCollectionViewCell.self,
            forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        registrationView.photoCollectionView.register(
            AddImageCollectionViewCell.self,
            forCellWithReuseIdentifier: AddImageCollectionViewCell.identifier)
    }
}

// MARK: - ItemRegisterAndModifyFormViewDelegate
extension ItemRegistrationViewController: ItemRegisterAndModifyFormViewDelegate {
    func setupNavigationBar() {
        navigationController?.navigationBar.scrollEdgeAppearance = registrationView.navigationBarAppearance
        self.navigationItem.rightBarButtonItem = registrationView.navigationBarDoneButton
        self.navigationItem.leftBarButtonItem = registrationView.navigationBarCanceButton
    }

    func dismiss() {
        pickImage()
        dismiss(animated: true, completion: nil)
    }

    func fillWithInformation(
        _ name: String?,
        _ description: String?,
        _ price: String?,
        _ currency: String,
        _ discountedPrice: String?,
        _ stock: String?) {
        manager.fillWithInformation(name, description, price, currency, discountedPrice, stock)
        manager.sendRequest(mode)
    }
}

// MARK: - UICollectionViewDataSource
extension ItemRegistrationViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let totalNumberOfImages = manager.countNumberOfModels()
        return totalNumberOfImages
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let photoModel: CellType = (manager.selectPhotoModel(by: indexPath.row))
        switch photoModel {
        case .image(let photoModel):
            guard let cell =
                    registrationView.photoCollectionView
                    .dequeueReusableCell(
                        withReuseIdentifier: ImageCollectionViewCell.identifier,
                        for: indexPath) as? ImageCollectionViewCell else {
                return ImageCollectionViewCell()
            }
            cell.setImage(with: photoModel)
            return cell
        case .addImage:
            guard let cell =
                    registrationView.photoCollectionView
                    .dequeueReusableCell(
                        withReuseIdentifier: AddImageCollectionViewCell.identifier,
                        for: indexPath) as? AddImageCollectionViewCell else {
                return AddImageCollectionViewCell()
            }
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ItemRegistrationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let totalNumberOfImages = manager.countNumberOfModels()
        if totalNumberOfImages < 6 {
            let photoModel: CellType = manager.selectPhotoModel(by: indexPath.row)
            if case .addImage = photoModel {
                pickImage()
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ItemRegistrationViewController: UIImagePickerControllerDelegate,
                                          UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let newImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            manager.appendToPhotoModel(with: newImage)
            registrationView.photoCollectionView.reloadData()
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @objc func pickImage() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}
