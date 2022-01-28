import UIKit

class ItemRegistrationViewController: UIViewController {

    private let registrationView = ItemRegisterAndModifyFormView()
    private let itemRegisterManager = ItemRegisterAndModifyManager()
    private let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupNavigationBar()
        registrationView.formViewDidLoad()
        view = registrationView
    }

    private func setupDelegate() {
        registrationView.photoCollectionView.delegate = self
        registrationView.photoCollectionView.dataSource = self
        imagePicker.delegate = self
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneButtonDidTap))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(cancelButtonDidTap))
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.leftBarButtonItem = cancelButton
    }

    @objc private func doneButtonDidTap() {
        let currency = registrationView.currencySegmentedControl.titleForSegment(at: registrationView.currencySegmentedControl.selectedSegmentIndex)!
        itemRegisterManager.createItem(by: .register,
                                       registrationView.nameInputTextField.text,
                                       registrationView.descriptionInputTextView.text,
                                       registrationView.priceInputTextField.text,
                                       currency,
                                       registrationView.discountedPriceInputTextField.text,
                                       registrationView.stockInputTextField.text)
    }

    @objc private func cancelButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension ItemRegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let newImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            itemRegisterManager.appendModel(with: newImage)
            registrationView.photoCollectionView.reloadData()
        }
        self.dismiss(animated: true, completion: nil)
    }

    @objc func pickImage() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }
}

extension ItemRegistrationViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemRegisterManager.getModelsCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model: CellType = itemRegisterManager.getModel(at: indexPath.row)

        switch model {
        case .image(let model):
            let cell = registrationView.photoCollectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
            cell.setImage(with: model)
            return cell
        case .addImage:
            let cell = registrationView.photoCollectionView.dequeueReusableCell(withReuseIdentifier: AddImageCollectionViewCell.reuseIdentifier, for: indexPath) as! AddImageCollectionViewCell
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let totalNumberOfImages = itemRegisterManager.getModelsCount()
        if totalNumberOfImages < 6 {
            let model: CellType = itemRegisterManager.getModel(at: indexPath.row)
            if case .addImage = model {
                pickImage()
            }
        }
    }
}
