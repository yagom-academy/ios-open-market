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
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        imageCollectionView.dataSource = dataSource
        imageCollectionView.delegate = self
        snapShot.appendSections([0])
        configureView()
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
        (print("POST"))
        post {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
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
        configureZoomedImageView()
    }
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

        textFieldStackView.addArrangedSubview(priceStackView)
        priceStackView.axis = .horizontal
        priceStackView.spacing = 7

        priceStackView.addArrangedSubview(priceTextField)
        priceTextField.borderStyle = .roundedRect
        priceTextField.placeholder = "상품가격"

        textFieldStackView.addArrangedSubview(discountTextField)
        discountTextField.borderStyle = .roundedRect
        discountTextField.placeholder = "할인금액"

        textFieldStackView.addArrangedSubview(stockTextField)
        stockTextField.borderStyle = .roundedRect
        stockTextField.placeholder = "재고수량"
    }

    private func configureSegmentControl() {
        priceStackView.addArrangedSubview(currencySegmentedControl)
        currencySegmentedControl.selectedSegmentIndex = 0
        currencySegmentedControl.backgroundColor = .systemGray5
        currencySegmentedControl.insertSegment(withTitle: "\(Currency.KRW)", at: 0, animated: false)
        currencySegmentedControl.insertSegment(withTitle: "\(Currency.USD)", at: 1, animated: false)
    }

    private func configureTextView() {
        stackView.addArrangedSubview(descriptionTextView)
        descriptionTextView.allowsEditingTextAttributes = true
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.delegate = self
        descriptionTextView.text = "여기에 상품 설명을 입력하세요!(글자 수 1000자 제한)"
        descriptionTextView.textColor = .placeholderText
        descriptionTextView.font = .preferredFont(forTextStyle: .body, compatibleWith: .current)

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
}

// MARK: - ImageCollectionView Configuration
extension AddProductViewController {
    private func makeCollectionView() -> UICollectionView {
        UICollectionView(frame: .zero, collectionViewLayout: configureImageCollectionViewLayout())
    }

    private func makeDatasource() -> UICollectionViewDiffableDataSource<Int, UIImage> {
        let cellRegistration = UICollectionView.CellRegistration<ImageCollectionViewCell, UIImage> { (cell, indexPath, image) in
            cell.imageView.image = image
            cell.imageView.contentMode = .scaleAspectFit
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
    
    func requestParamsForPost() throws -> CreateProductRequestParams {
        guard let name = nameTextField.text,
              (3...100).contains(name.count) else {
            throw CreateProductError.invalidProductName
        }
        guard let descriptions = descriptionTextView.text,
              (10...1000).contains(descriptions.count) else {
            throw CreateProductError.invalidDescription
        }
        guard let priceInString = priceTextField.text,
              let priceInDecimal = Decimal(string: priceInString, locale: .none) else {
            throw CreateProductError.invalidPrice
        }
        guard let discountedPriceInString = priceTextField.text,
              let discountedPriceInDecimal = Decimal(string: discountedPriceInString, locale: .none) else {
            throw CreateProductError.invalidDiscountedPrice
        }
        let discountedPrice = (0...priceInDecimal).contains(discountedPriceInDecimal) ? discountedPriceInDecimal : 0
        let stockInString = stockTextField.text ?? "0"
        let stockInInt = Int(stockInString) ?? 0
        let secret = "!QA4M%Lat9yF-?RW"

        return CreateProductRequestParams(name: name,
                                   descriptions: descriptions,
                                   price: priceInDecimal,
                                   currency: currencySegmentedControl.selectedSegmentIndex == 0 ?
                                    .KRW : .USD,
                                   discountedPrice: discountedPrice,
                                   stock: stockInInt,
                                   secret: secret)
    }

    func createPostService() throws -> OpenMarketService {

        let params: Data = try JSONEncoder().encode(requestParamsForPost())

        let images: [Image] = {
            var imageIdentifiers = snapShot.itemIdentifiers.compactMap { image -> Image? in
                guard let pngData = image.pngData() else { return nil }
                return Image(type: .png, data: pngData)
            }
            imageIdentifiers.removeLast()
            return imageIdentifiers
        }()

        guard (1...5).contains(images.count) else {
            throw CreateProductError.invalidImages
        }

        return OpenMarketService.createProduct(sellerID: "1c51912b-7215-11ec-abfa-13ae6fd5cdba", params: params, images: images)
    }

    func presentErrorAlert(error: CreateProductError) {
        let alertController = UIAlertController(title: error.errorDescription,
                                                message: error.recoverySuggestion,
                                                preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }


    
    func post(completion: @escaping () -> Void) {
        let provider = URLSessionProvider(session: URLSession(configuration: .default))

        do {
            provider.request(try createPostService()) { result in
                switch result {
                case .success:
                    completion()
                case .failure:
                    DispatchQueue.main.async {
                        self.presentErrorAlert(error: .createFailure)
                    }
                }
            }
        } catch let error as CreateProductError {
            presentErrorAlert(error: error)
        } catch {
            presentErrorAlert(error: .createFailure)
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
        textView.textColor = .label
        textView.text = ""
    }
    func textViewDidChange(_ textView: UITextView) {
        let textCount = textView.text.count
        if textCount >= 1000 {
            textView.text.removeLast(textCount - 1000)
        }
    }
}
enum CreateProductError: Error {
    case invalidProductName
    case invalidDescription
    case invalidPrice
    case invalidDiscountedPrice
    case invalidImages
    case createFailure
}
extension CreateProductError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidProductName:
            return "잘못된 상품명이에요"
        case .invalidDescription:
            return "잘못된 상품설명이에요"
        case .invalidPrice:
            return "가격 입력이 잘못되었습니다"
        case .invalidDiscountedPrice:
            return "할인가격 입력이 잘못되었습니다"
        case .invalidImages:
            return "사진을 등록에 문제가 있어요"
        case .createFailure:
            return "상품 등록에 실패하였습니다"
        }
    }
    var recoverySuggestion: String? {
        switch self {
        case .invalidProductName:
            return "상품명은 3자 이상 100자 이내로 작성하세요"
        case .invalidDescription:
            return "상품 설명은 최소 10자 최대 1000자로 작성해 주세요"
        case .invalidPrice, .invalidDiscountedPrice:
            return "혹시 숫자 이외의 값을 입력하셨나요?"
        case .invalidImages:
            return "상품 사진은 최소 1장, 최대 5장까지 등록할 수 있어요"
        case .createFailure:
            return nil
        }
    }
}
