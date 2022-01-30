import UIKit

extension ItemRegisterAndModifyManager: ItemRegisterAndModifyFormViewDataSource {}

protocol ItemRegisterAndModifyFormViewDataSource: AnyObject {
    func countNumberOfModels() -> Int
    func selectPhotoModel(by index: Int) -> CellType
    func appendToPhotoModel(with image: UIImage)
}

protocol ItemRegisterAndModifyFormViewDelegate: AnyObject {
    func setupNavigationBar()
    func register()
    func dismiss()
    func presentImagePicker(_ imagePicker: UIImagePickerController)
}

class ItemRegisterAndModifyFormView: UIView {
    weak var dataSource: ItemRegisterAndModifyFormViewDataSource?
    weak var delegate: ItemRegisterAndModifyFormViewDelegate?
    private let imagePicker = UIImagePickerController()
    let navigationBarAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        return appearance
    }()
    let navigationBarDoneButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonDidTap))
        return barButton
    }()
    let navigationBarCanceButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonDidTap))
        return barButton
    }()
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    let contentView: UIStackView = {
        let contentView = UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.distribution = .fill
        contentView.alignment = .fill
        contentView.spacing = 10
        contentView.backgroundColor = .systemBackground
        return contentView
    }()
    let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 130, height: 130)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.isDirectionalLockEnabled = true
        collectionView.register(
            ImageCollectionViewCell.self,
            forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.register(
            AddImageCollectionViewCell.self,
            forCellWithReuseIdentifier: AddImageCollectionViewCell.identifier)
        return collectionView
    }()
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    }()
    let currencySegmentedControl: UISegmentedControl = {
        let items = [Currency.KRW.rawValue, Currency.USD.rawValue]
        let segmentedControl = UISegmentedControl(items: items)
        let selectedText = [NSAttributedString.Key.backgroundColor: UIColor.white]
        let defaultText = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.apportionsSegmentWidthsByContent = true
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    let nameInputTextField: ItemInformationTextField = {
        let textField = ItemInformationTextField(type: .name)
        return textField
    }()
    let priceInputTextField: ItemInformationTextField = {
        let textField = ItemInformationTextField(type: .price)
        textField.keyboardType = .decimalPad
        textField.setContentCompressionResistancePriority(.required, for: .horizontal)
        return textField
    }()
    let discountedPriceInputTextField: ItemInformationTextField = {
        let textField = ItemInformationTextField(type: .discountedPrice)
        textField.keyboardType = .decimalPad
        return textField
    }()
    let stockInputTextField: ItemInformationTextField = {
        let textField = ItemInformationTextField(type: .stock)
        textField.keyboardType = .numberPad
        return textField
    }()
    let descriptionInputTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        return textView
    }()
    func formViewDidLoad() {
        setupDelegate()
        setupNavigationBar()
        setupViews()
        setupConstraints()
        addKeyboardNotificationObservers()
        addKeyboardDismissGestureRecognizer()
    }

    private func setupDelegate() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }

    private func setupNavigationBar() {
        delegate?.setupNavigationBar()
    }

    @objc private func doneButtonDidTap() {
        delegate?.register()
    }

    @objc private func cancelButtonDidTap() {
        delegate?.dismiss()
    }
    private func setupViews() {
        priceStackView.addArrangedSubview(priceInputTextField)
        priceStackView.addArrangedSubview(currencySegmentedControl)
        contentView.addArrangedSubview(photoCollectionView)
        contentView.addArrangedSubview(nameInputTextField)
        contentView.addArrangedSubview(priceStackView)
        contentView.addArrangedSubview(discountedPriceInputTextField)
        contentView.addArrangedSubview(stockInputTextField)
        contentView.addArrangedSubview(descriptionInputTextView)
        scrollView.addSubview(contentView)
        self.addSubview(scrollView)
        self.backgroundColor = .white
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            photoCollectionView.heightAnchor.constraint(equalToConstant: 130),
            nameInputTextField.heightAnchor.constraint(equalToConstant: 31),
            currencySegmentedControl.widthAnchor.constraint(equalToConstant: 100),
            priceStackView.heightAnchor.constraint(equalToConstant: 31),
            discountedPriceInputTextField.heightAnchor.constraint(equalToConstant: 31),
            stockInputTextField.heightAnchor.constraint(equalToConstant: 31),
            descriptionInputTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150)
        ])
    }
}

extension ItemRegisterAndModifyFormView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let totalNumberOfImages = dataSource?.countNumberOfModels() else {
            return .zero
        }
        return totalNumberOfImages
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let photoModel: CellType = (dataSource?.selectPhotoModel(by: indexPath.row)) else {
            return UICollectionViewCell()
        }
        switch photoModel {
        case .image(let photoModel):
            guard let cell =
                    photoCollectionView
                    .dequeueReusableCell(
                        withReuseIdentifier: ImageCollectionViewCell.identifier,
                        for: indexPath) as? ImageCollectionViewCell else {
                return ImageCollectionViewCell()
            }
            cell.setImage(with: photoModel)
            return cell
        case .addImage:
            guard let cell =
                    photoCollectionView
                    .dequeueReusableCell(
                        withReuseIdentifier: AddImageCollectionViewCell.identifier,
                        for: indexPath) as? AddImageCollectionViewCell else {
                return AddImageCollectionViewCell()
            }
            return cell

        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let totalNumberOfImages = dataSource?.countNumberOfModels() else {
            return
        }
        if totalNumberOfImages < 6 {
            guard let photoModel: CellType = dataSource?.selectPhotoModel(by: indexPath.row) else {
                return
            }
            if case .addImage = photoModel {
                pickImage()
            }
        }
    }
}

extension ItemRegisterAndModifyFormView: UIImagePickerControllerDelegate,
                                         UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let newImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            dataSource?.appendToPhotoModel(with: newImage)
            photoCollectionView.reloadData()
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @objc func pickImage() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        delegate?.presentImagePicker(imagePicker)
    }
}

extension ItemRegisterAndModifyFormView {
    private func addKeyboardNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame =
                userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        scrollView.contentInset.bottom = keyboardFrame.height / 2
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                           constant: -keyboardFrame.height).isActive = true

        guard let duration =
                userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInset: UIEdgeInsets = .zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true

        guard let userInfo = notification.userInfo,
              let duration =
                userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }

    private func addKeyboardDismissGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
        removeKeyboardNotificationObservers()
    }

    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }

    private func removeKeyboardNotificationObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

}
