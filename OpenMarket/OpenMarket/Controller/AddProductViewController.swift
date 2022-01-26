//
//  AddProductViewController.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/20.
//

import UIKit

class AddProductViewController: UIViewController, UINavigationControllerDelegate {

    private lazy var imageCollectionView = makeCollectionView()
    private lazy var dataSource = makeDatasource()
    private lazy var snapShot = NSDiffableDataSourceSnapshot<Int, UIImage>()

    private lazy var scrollView = UIScrollView()
    private lazy var stackView = UIStackView()
    private lazy var textFieldStackView = UIStackView()
    private lazy var nameTextField = UITextField()
    private lazy var priceStackView = UIStackView()
    private lazy var priceTextField = UITextField()
    private lazy var currencySegmentedControl = UISegmentedControl()
    private lazy var discountTextField = UITextField()
    private lazy var stockTextField = UITextField()
    private lazy var descriptionTextView = UITextView()
    private lazy var zoomedImageView = UIImageView()

    private lazy var picker = UIImagePickerController()
    private var imageCount = 0
    private let defaultImage = UIImage(named: "addPhoto")!

    private let postManager = PostManager()
    private var inputData: UnboundDataForPost {
        UnboundDataForPost(name: nameTextField.text,
                           descriptions: descriptionTextView.text,
                           price: priceTextField.text,
                           currency: currencySegmentedControl.selectedSegmentIndex == 0 ? .KRW : .USD,
                           discountedPrice: discountTextField.text,
                           stock: stockTextField.text,
                           images: snapShot.itemIdentifiers)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        imageCollectionView.dataSource = dataSource
        imageCollectionView.delegate = self
        snapShot.appendSections([0])
        postManager.setDelegate(self)
        configureView()
        configureKeyboard()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        snapShot.appendItems([defaultImage])
        dataSource.apply(snapShot)
    }

}

// MARK: - Action Method
extension AddProductViewController {
    @objc
    func closeButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc
    func doneButtonDidTap() {
        postManager.post(data: inputData) {
            self.postManagerDidSuccessPosting()
        }
    }

    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        }
    }

    @objc
    private func keyboardDidHide(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - View Configuration
extension AddProductViewController {
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        
        configureScrollView()
        configureNavigationBar()
        configureStackView()
        configureImageCollectionView()
        configureTextFields()
        configureSegmentControl()
        configureTextView()
        configureZoomedImageView()    }
    private func configureNavigationBar() {
        title = "상품등록"

        let closeButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeButtonDidTap))
        navigationItem.leftBarButtonItem = closeButton

        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonDidTap))
        navigationItem.rightBarButtonItem = doneButton
    }

    private func configureScrollView() {
        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.contentLayoutGuide.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.safeAreaLayoutGuide.heightAnchor)
        ])
    }
    
    private func configureStackView() {
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }

    private func configureImageCollectionView() {
        stackView.addArrangedSubview(imageCollectionView)
        imageCollectionView.isScrollEnabled = false
        imageCollectionView.backgroundColor = .systemBackground
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageCollectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            imageCollectionView.heightAnchor.constraint(equalTo: imageCollectionView.widthAnchor, multiplier: 0.4)
        ])
    }

    private func configureTextFields() {
        stackView.addArrangedSubview(textFieldStackView)
        textFieldStackView.axis = .vertical
        textFieldStackView.spacing = 7

        textFieldStackView.addArrangedSubview(nameTextField)
        nameTextField.borderStyle = .roundedRect
        nameTextField.placeholder = "상품명"
        nameTextField.adjustsFontForContentSizeCategory = true

        textFieldStackView.addArrangedSubview(priceStackView)
        priceStackView.axis = .horizontal
        priceStackView.spacing = 7

        priceStackView.addArrangedSubview(priceTextField)
        priceTextField.borderStyle = .roundedRect
        priceTextField.placeholder = "상품가격"
        priceTextField.adjustsFontForContentSizeCategory = true
        priceTextField.keyboardType = .decimalPad

        textFieldStackView.addArrangedSubview(discountTextField)
        discountTextField.borderStyle = .roundedRect
        discountTextField.placeholder = "할인금액"
        discountTextField.adjustsFontForContentSizeCategory = true
        discountTextField.keyboardType = .decimalPad

        textFieldStackView.addArrangedSubview(stockTextField)
        stockTextField.borderStyle = .roundedRect
        stockTextField.placeholder = "재고수량"
        stockTextField.adjustsFontForContentSizeCategory = true
        stockTextField.keyboardType = .numberPad
    }

    private func configureSegmentControl() {
        priceStackView.addArrangedSubview(currencySegmentedControl)
        currencySegmentedControl.backgroundColor = .systemGray5
        currencySegmentedControl.insertSegment(withTitle: "\(Currency.KRW)", at: 0, animated: false)
        currencySegmentedControl.insertSegment(withTitle: "\(Currency.USD)", at: 1, animated: false)
        currencySegmentedControl.selectedSegmentIndex = 0
    }

    private func configureTextView() {
        stackView.addArrangedSubview(descriptionTextView)
        descriptionTextView.allowsEditingTextAttributes = true
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.delegate = self
        descriptionTextView.text = "여기에 상품 설명을 입력하세요. (1000글자 제한)"
        descriptionTextView.textColor = .placeholderText
        descriptionTextView.font = .preferredFont(forTextStyle: .body, compatibleWith: .current)
        descriptionTextView.adjustsFontForContentSizeCategory = true

        descriptionTextView.setContentHuggingPriority(.init(0), for: .vertical)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            descriptionTextView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }

    private func configureZoomedImageView() {
        view.addSubview(zoomedImageView)
        zoomedImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            zoomedImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            zoomedImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            zoomedImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            zoomedImageView.heightAnchor.constraint(equalTo: view.widthAnchor)
        ])
        zoomedImageView.alpha = 0
    }

    private func configureKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
}

// MARK: - ImageCollectionView Configuration
extension AddProductViewController {
    private func makeCollectionView() -> UICollectionView {
        UICollectionView(frame: .zero, collectionViewLayout: configureImageCollectionViewLayout())
    }

    private func makeDatasource() -> UICollectionViewDiffableDataSource<Int, UIImage> {
        let cellRegistration = UICollectionView.CellRegistration<ImageCollectionViewCell, UIImage> { (cell, indexPath, image) in
            cell.imageView.image = image
        }
        dataSource = UICollectionViewDiffableDataSource<Int, UIImage>(collectionView: imageCollectionView) { (collectionView, indexPath, image) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: image)
        }
        return dataSource
    }

    private func configureImageCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: - ImageCollectionView Related
extension AddProductViewController {

    private func presentPicker(sourceType: UIImagePickerController.SourceType) {
        let galleryPicker = UIImagePickerController()
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        galleryPicker.sourceType = sourceType
        galleryPicker.allowsEditing = true
        galleryPicker.imageExportPreset = .compatible
        galleryPicker.delegate = self
        if sourceType == .camera {
            galleryPicker.showsCameraControls = true
            galleryPicker.cameraDevice = .rear
            galleryPicker.cameraCaptureMode = .photo
        }
        present(galleryPicker, animated: true, completion: nil)
    }

    private func appendImage(_ image: UIImage) {
        guard imageCount < 5,
              let lastID = snapShot.itemIdentifiers.last else { return }
        snapShot.deleteItems([lastID])
        if imageCount == 4 {
            snapShot.appendItems([image])
        } else {
            snapShot.appendItems([image, defaultImage])
        }
        dataSource.apply(snapShot)
        imageCount += 1
    }

    private func showImageSelectionAlert(completion: (() -> Void)?) {
        let alert = UIAlertController(title: "상품 사진 등록", message: nil, preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: "카메라", style: .default) { _ in
            self.presentPicker(sourceType: .camera)
        }
        let gallery = UIAlertAction(title: "사진", style: .default) { _ in
            self.presentPicker(sourceType: .photoLibrary)
        }
        alert.addAction(photo)
        alert.addAction(gallery)
        present(alert, animated: true, completion: completion)
    }

    private func deleteImage(at index: Int) {
        guard imageCount != 0 else { return }
        snapShot.deleteItems([snapShot.itemIdentifiers[index]])
        dataSource.apply(snapShot)
        imageCount -= 1
    }

    private func showImageReviseAlert(at index: Int) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let replaceAction = UIAlertAction(title: "Replace", style: .default) { _ in
            self.showImageSelectionAlert {
                self.zoomedImageView.alpha = 0
                self.snapShot.deleteItems([self.snapShot.itemIdentifiers[index]])
                self.imageCount -= 1
            }
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.zoomedImageView.alpha = 0
            self.deleteImage(at: index)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            UIView.animate(withDuration: 0.5) {
                self.zoomedImageView.alpha = 0
            }
        }
        alert.addAction(replaceAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        zoomedImageView.image = snapShot.itemIdentifiers[index]
        UIView.animate(withDuration: 0.5) {
            self.zoomedImageView.alpha = 1.0
        }

        present(alert, animated: true, completion: nil)
    }

    func presentErrorAlert(error: CreateProductError) {
        let alertController = UIAlertController(title: error.errorDescription,
                                                message: error.recoverySuggestion,
                                                preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }

}

// MARK: - Delegate Protocol Requirements
extension AddProductViewController: PostResultRepresentable {
    func postManagerDidSuccessPosting() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

    func postManager(didFailPostingWithError error: CreateProductError) {
        DispatchQueue.main.async {
            self.presentErrorAlert(error: error)
        }
    }
}

extension AddProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexPath.item == imageCount ?
            showImageSelectionAlert(completion: nil)
            : showImageReviseAlert(at: indexPath.item)
    }
}

extension AddProductViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        appendImage(image)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddProductViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor != .label {
            textView.textColor = .label
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "여기에 상품 설명을 입력하세요. (1000글자 제한)"
            textView.textColor = .placeholderText
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        let textCount = textView.text.count
        if textCount >= 1000 {
            textView.text.removeLast(textCount - 1000)
        }
    }
}
