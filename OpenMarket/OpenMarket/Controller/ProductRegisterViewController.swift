import UIKit

class ProductRegisterViewController: UIViewController {

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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(stackView)
        stackView.imageCollectionView.delegate = self
        configureConstraint()
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

}

// MARK: Collection View Delegate
extension ProductRegisterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == indexPath.count - 1 {
            showActionSheet()
        }
    }
}
