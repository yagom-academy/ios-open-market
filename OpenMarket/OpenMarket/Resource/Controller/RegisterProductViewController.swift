//
//  RegisterProductViewController.swift
//  OpenMarket
//
//  Created by baem, minii on 2022/12/02.
//

import UIKit

final class RegisterProductViewController: UIViewController {
    // MARK: - Properties
    var isEditingMode: Bool = false {
        didSet {
            if isEditingMode {
                navigationItem.title = "상품수정"
            } else {
                navigationItem.title = "상품등록"
            }
            
            collectionView.reloadData()
        }
    }
    var selectedImage = Array<UIImage?>(repeating: nil, count: 5)
    var selectedCurrency = Currency.KRW {
        didSet {
            changeKeyboard()
        }
    }
    
    var selectedIndex: Int = 0
    let networkManager = NetworkManager<ProductListResponse>()
    
    // MARK: - View Properties
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            RegisterCollectionImageCell.self,
            forCellWithReuseIdentifier: RegisterCollectionImageCell.identifier
        )
        return collectionView
    }()
    
    let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "상품명"
        
        return textField
    }()
    
    let productPriceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "상품가격"
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    let discountPriceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "할인금액"
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    let stockTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "재고수량"
        
        return textField
    }()
    
    lazy var currencySegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: Currency.allCases.map(\.rawValue))
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(changeSegmentValue), for: .valueChanged)
        
        return segment
    }()
    
    lazy var descriptionTextView: UITextView = {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTappedTextViewDoneButton))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        let textview = UITextView()
        textview.text = "설명"
        textview.textColor = .secondaryLabel
        textview.font = .preferredFont(forTextStyle: .body)
        textview.inputAccessoryView = toolbar
        textview.autocorrectionType = .no
        textview.keyboardType = .default
        textview.autocapitalizationType = .none
        textview.spellCheckingType = .no
        textview.contentInset = stockTextField.safeAreaInsets
        
        textview.delegate = self
        
        return textview
    }()
    
    lazy var segmentStackview: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.addArrangedSubview(productPriceTextField)
        stackView.addArrangedSubview(currencySegment)
        stackView.spacing = 8
        currencySegment.widthAnchor.constraint(equalTo: productPriceTextField.widthAnchor, multiplier: 0.30).isActive = true
        
        return stackView
    }()
    
    lazy var totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        [
            productNameTextField,
            segmentStackview,
            discountPriceTextField,
            stockTextField
        ].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        return stackView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        setUpDelegate()
        setUpConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
}

enum ConvertPostError: Error {
    case wrongName
    case wrongDescription
    case wrongPrice
    case wrongCurrency
    case wrongDiscount
    case wrongStock
}

// MARK: - Business Logic
private extension RegisterProductViewController {
    func convertPostParameters() throws -> PostParameter {
        // TODO: - 요소 검사 로직 추가하기
        // TODO: - 너무 많은 guard문을 사용하는 것을 어떻게 해결할까?
        guard let name = productNameTextField.text else {
            throw ConvertPostError.wrongName
        }
        
        guard let description = descriptionTextView.text else {
            throw ConvertPostError.wrongDescription
        }
        
        guard let priceText = productPriceTextField.text,
              let price = Double(priceText) else {
            throw ConvertPostError.wrongPrice
        }
        
        guard let currency = Currency(rawInt: currencySegment.selectedSegmentIndex) else {
            throw ConvertPostError.wrongCurrency
        }
        
        guard let discountText = discountPriceTextField.text,
              let discounted = Double(discountText) else {
            throw ConvertPostError.wrongDiscount
        }
        
        guard let stockText = stockTextField.text,
              let stock = Int(stockText) else {
            throw ConvertPostError.wrongStock
        }
        
        return .init(name: name, description: description, price: price, currency: currency, discounted_price: discounted, stock: stock)
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
        guard let params = try? convertPostParameters() else {
            return
        }
        
        var httpBodies = selectedImage.compactMap { $0?.convertHttpBody() }
        httpBodies.insert(params.convertHttpBody(), at: 0)

        let postPoint = OpenMarketAPI.addProduct(sendId: UUID(), bodies: httpBodies)
        
        networkManager.postProduct(endPoint: postPoint) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                // TODO: - Error Alert 띄우기
                print(error)
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
        navigationItem.title = "상품등록"
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
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.2),
            
            totalStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            totalStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            totalStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: totalStackView.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            descriptionTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
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
        
        if images.count < 5 {
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
        let contentWidth = viewSize.width / 3 - 10
        
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
            // 만약에 이미지 비율이 1이 아니면 -> 이미지의 비율을 1로 변경해주는 cropping을 한다.
            var originImage = image
            var imageScale = 1.0
            var imageSize = originImage.compressionSize
            
            if originImage.size.height != originImage.size.width {
                originImage = originImage.resizeOfSquare()
                imageSize = originImage.compressionSize
            }
            
            while imageSize ?? 0 > 60000 {
                originImage = originImage.downSampling(scale: imageScale)
                imageSize = originImage.compressionSize
                imageScale -= 0.1
            }
            
            selectedImage[selectedIndex] = originImage
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
        view.frame.origin.y = 0
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
        
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: accessoryView.frame.height, right: 0)
        
        view.frame.origin.y = -(textView.frame.origin.y - view.safeAreaInsets.top)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "설명"
            textView.textColor = .secondaryLabel
        }
    }
}
