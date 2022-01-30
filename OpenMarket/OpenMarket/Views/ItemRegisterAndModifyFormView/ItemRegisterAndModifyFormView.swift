import UIKit

class ItemRegisterAndModifyFormView: UIView {
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
        setupViews()
        setupConstraints()
        addKeyboardNotificationObservers()
        addKeyboardDismissGestureRecognizer()
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
