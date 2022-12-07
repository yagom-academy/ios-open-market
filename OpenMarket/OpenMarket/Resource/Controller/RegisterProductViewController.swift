//
//  RegisterProductViewController.swift
//  OpenMarket
//
//  Created by baem, minii on 2022/12/02.
//

// TODO: - 추가적으로 할일
/*
 4. pagenation 구현하기
 */

import UIKit

final class RegisterProductViewController: UIViewController {
    enum Constant {
        static let editProduct: String = "상품수정"
        static let registerProduct: String = "상품등록"
        static let maxImageCount: Int = 5
        
        static let productName: String = "상품명"
        static let productPrice: String = "상품가격"
        static let discountPrice: String = "할인금액"
        static let stockCount: String = "재고수량"
        static let description: String = "설명"
        
        static let baseSpacing: CGFloat = 8
        
        static let horizontalSpacing: CGFloat = 16
        static let collectionViewVerticalRatio: CGFloat = 0.2
        static let segmentHorizontalRatio: CGFloat = 0.3
        
        static let confirm: String = "확인"
        static let done: String = "Done"
        
        static let rowCount: CGFloat = 3
        static let insetValue: CGFloat = 10
    }
    
    // MARK: - Properties
    private var isEditingMode: Bool = false {
        didSet {
            if isEditingMode {
                navigationItem.title = Constant.editProduct
            } else {
                navigationItem.title = Constant.registerProduct
            }
            
            collectionView.reloadData()
        }
    }
    private var selectedCurrency = Currency.KRW {
        didSet {
            changeKeyboard()
        }
    }
    
    private var selectedImage = Array<UIImage?>(repeating: nil, count: Constant.maxImageCount)
    private var selectedIndex: Int = .zero
    private let networkManager = NetworkManager<ProductListResponse>()
    
    // MARK: - View Properties
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let productNameTextField = UITextField(placeholder: Constant.productName)
    private let productPriceTextField = UITextField(placeholder: Constant.productPrice, keyboardType: .numberPad)
    private let discountPriceTextField = UITextField(placeholder: Constant.discountPrice, keyboardType: .numberPad)
    private let stockTextField = UITextField(placeholder: Constant.stockCount, keyboardType: .numberPad)
    
    private let currencySegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: Currency.allCases.map(\.rawValue))
        segment.selectedSegmentIndex = .zero
        return segment
    }()
    
    private let descriptionTextView = UITextView(text: Constant.description, textColor: .secondaryLabel, font: .preferredFont(forTextStyle: .body), spellCheckingType: .no)
    
    private let segmentStackView = UIStackView(axis: .horizontal, distribution: .fill, spacing: Constant.baseSpacing)
    
    private let totalStackView = UIStackView(axis: .vertical, distribution: .equalSpacing, spacing: Constant.baseSpacing)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        currencySegment.addTarget(self, action: #selector(changeSegmentValue), for: .valueChanged)
        
        setupDescriptionTextViewAccessoryView()
        setupSubViewInStackViews()
        configureNavigation()
        setUpDelegate()
        setUpConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
}

// MARK: - Business Logic
private extension RegisterProductViewController {
    func convertPostParameters() -> PostParameter? {
        let checker = RegisterProductChecker { [weak self] error in
            guard let self = self else { return }
            self.presentAlertMessage(error: error)
        }
        
        checker.invalidImage(images: selectedImage)
        guard let name = checker.invalidName(textField: productNameTextField),
              let description = checker.invalidDescription(textView: descriptionTextView),
              let price = checker.invalidPrice(textField: productPriceTextField),
              let currency = checker.invalidCurrency(segment: currencySegment),
              let discounted = checker.invalidDiscountedPrice(textField: discountPriceTextField, price: price) else {
            return nil
        }
        let stock = Int(stockTextField.text ?? Int.zero.description)
        
        return PostParameter(name: name, description: description, price: price, currency: currency, discounted_price: discounted, stock: stock)
    }
}

// MARK: - Objc Method
private extension RegisterProductViewController {
    @objc func didTappedTextViewDoneButton() {
        view.frame.origin.y = .zero
        additionalSafeAreaInsets = .zero
        descriptionTextView.endEditing(true)
    }
    
    @objc func didTappedNavigationDoneButton() {
        guard let params = convertPostParameters() else {
            return
        }
        
        var httpBodies = selectedImage.compactMap { $0?.convertHttpBody() }
        httpBodies.insert(params.convertHttpBody(), at: .zero)
        
        let postPoint = OpenMarketAPI.addProduct(sendId: UUID(), bodies: httpBodies)
        
        networkManager.postProduct(endPoint: postPoint) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                switch result {
                case .success(_):
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    self.presentAlertMessage(error: error)
                }
            }
        }
    }
    
    @objc func changeSegmentValue() {
        switch Currency(rawInt: currencySegment.selectedSegmentIndex) {
        case .none:
            return
        case .some(let currency):
            self.selectedCurrency = currency
        }
        
        view.endEditing(true)
    }
}

// MARK: - Configure UI
private extension RegisterProductViewController {
    func configureNavigation() {
        let rightButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTappedNavigationDoneButton)
        )
        
        navigationItem.rightBarButtonItem = rightButton
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = Constant.registerProduct
    }
    
    func setupSubViewInStackViews() {
        segmentStackView.configureSubViews(subViews: [productPriceTextField, currencySegment])
        totalStackView.configureSubViews(subViews: [productNameTextField, segmentStackView, discountPriceTextField, stockTextField])
    }
    
    func setUpDelegate() {
        [
            stockTextField,
            productNameTextField,
            productPriceTextField,
            discountPriceTextField
        ].forEach {
            $0.delegate = self
        }
        
        descriptionTextView.delegate = self
        setupCollectionViewDelegate()
    }
    
    func setupCollectionViewDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            RegisterCollectionImageCell.self,
            forCellWithReuseIdentifier: RegisterCollectionImageCell.identifier
        )
    }
    
    func addSubViewsOfContent() {
        [
            collectionView,
            totalStackView,
            descriptionTextView,
            totalStackView,
            descriptionTextView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        addSubViewsOfContent()
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constant.horizontalSpacing),
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constant.horizontalSpacing),
            collectionView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: Constant.collectionViewVerticalRatio),
            
            totalStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            totalStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constant.horizontalSpacing),
            totalStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constant.horizontalSpacing),
            
            descriptionTextView.topAnchor.constraint(equalTo: totalStackView.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constant.horizontalSpacing),
            descriptionTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constant.horizontalSpacing),
            descriptionTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            currencySegment.widthAnchor.constraint(equalTo: productPriceTextField.widthAnchor, multiplier: Constant.segmentHorizontalRatio)
        ])
    }
    
    func changeKeyboard() {
        if selectedCurrency == Currency.KRW {
            productPriceTextField.keyboardType = .numberPad
            discountPriceTextField.keyboardType = .numberPad
        } else {
            productPriceTextField.keyboardType = .decimalPad
            discountPriceTextField.keyboardType = .decimalPad
        }
        
        productPriceTextField.text = nil
        discountPriceTextField.text = nil
    }
    
    func presentAlertMessage(error: RegisterError) {
        let alert = UIAlertController(title: error.rawValue, message: error.description, preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: Constant.confirm, style: .default, handler: nil)
        alert.addAction(confirmButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    func presentAlertMessage(error: NetworkError) {
        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: Constant.confirm, style: .default, handler: nil)
        alert.addAction(confirmButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    func setupDescriptionTextViewAccessoryView() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: Constant.done, style: .done, target: self, action: #selector(didTappedTextViewDoneButton))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionTextView.inputAccessoryView = toolbar
        descriptionTextView.contentInset = stockTextField.safeAreaInsets
    }
}

// MARK: - UICollectionViewDataSource
extension RegisterProductViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let images = selectedImage.compactMap { $0 }
        
        if isEditingMode {
            return images.count
        }
        
        if images.count < Constant.maxImageCount {
            return images.count + 1
        }
        
        return images.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RegisterCollectionImageCell.identifier,
            for: indexPath
        ) as? RegisterCollectionImageCell else {
            return UICollectionViewCell()
        }
        
        let filteredImage = selectedImage.compactMap { $0 }
        
        if indexPath.item == filteredImage.count {
            cell.configureButtonStyle()
        } else {
            cell.itemImageView.image = filteredImage[indexPath.item]
        }
        
        return cell
    }
}

// MARK: - UICollectinViewDelegateFlowLayout
extension RegisterProductViewController: UICollectionViewDelegateFlowLayout { }

// MARK: - UICollectionViewDelegate
extension RegisterProductViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let viewSize = view.frame.size
        let contentWidth = viewSize.width / Constant.rowCount - Constant.insetValue
        
        return CGSize(width: contentWidth, height: contentWidth)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if isEditingMode {
            return
        }
        
        selectedIndex = indexPath.item
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension RegisterProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage[selectedIndex] = image.convertDownSamplingImage()
        }
        
        collectionView.reloadData()
        picker.dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension RegisterProductViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        view.frame.origin.y = -textField.frame.origin.y
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.frame.origin.y = .zero
        textField.endEditing(true)
        return true
    }
}

// MARK: - UITextViewDelegate
extension RegisterProductViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondaryLabel {
            textView.text = nil
            textView.textColor = .label
        }
        
        guard let accessoryView = textView.inputAccessoryView else {
            return
        }
        
        additionalSafeAreaInsets = UIEdgeInsets(top: .zero, left: .zero, bottom: accessoryView.frame.height, right: .zero)
        
        view.frame.origin.y = -(textView.frame.origin.y - view.safeAreaInsets.top)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constant.description
            textView.textColor = .secondaryLabel
        }
    }
}
