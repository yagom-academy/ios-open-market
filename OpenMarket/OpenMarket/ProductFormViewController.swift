//
//  ProductDetailsController.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/21.
//

import UIKit

// MARK: - AddButtonTappedDelegate Protocol

protocol AddButtonTappedDelegate: AnyObject {
    func registerButtonTapped()
}

final class ProductFormViewController: UIViewController {
    
    // MARK: - Nested Type
    
    enum PageMode {
        case register
        case edit
        
        var description: String {
            switch self {
            case .register:
                return "상품등록"
            case .edit:
                return "상품수정"
            }
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var discountedPriceTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Properties
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        
        return imagePicker
    }()

    private var isValidRequiredInputs: Bool {
        return productNameTextField.isValid &&
            priceTextField.isValid &&
            descriptionTextView.isValid
    }
    
    private var images: [UIImage] = []
    private var productImages: [ProductImage] = []
    weak var delegate: AddButtonTappedDelegate?
    private var pageMode: PageMode
    
    // MARK: - Initializer
    
    init?(delegate: AddButtonTappedDelegate,
          pageMode: PageMode,
          coder: NSCoder
    ) {
        self.delegate = delegate
        self.pageMode = pageMode
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder: ) has not been implemented")
        return nil
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupCollectionViewCells()
        setNavigationBar()
        setPageMode()
        setTextFields()
        setSegmentedControlTitle()
        setTextViewPlaceholder()
        addTextViewObserver()
        hideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        productNameTextField.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    // MARK: - Internal Methods
    
    func triggerDelegateMethod() {
        delegate?.registerButtonTapped()
    }
}

//MARK: - IBActions

extension ProductFormViewController {
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard images.count > 0 else {
            AlertManager.presentNoImagesAlert(on: self)
            return
        }
        registerProduct()
        AlertManager.presentSuccessfulRegisterAlert(on: self)
    }
}

// MARK: - Private Methods

extension ProductFormViewController {
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = flowLayout
        collectionView.isPagingEnabled = true
        collectionView.decelerationRate = .fast
        descriptionTextView.delegate = self
        imagePicker.delegate = self
    }
    
    private func setupCollectionViewCells() {
        let imageCellNib = UINib(nibName: ImageCell.identifier, bundle: .main)
        let addImageButtonCellNib = UINib(nibName: AddImageButtonCell.identifier, bundle: .main)
        
        collectionView.register(imageCellNib, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.register(addImageButtonCellNib, forCellWithReuseIdentifier: AddImageButtonCell.identifier)
    }
    
    private func setNavigationBar() {
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
    }
    
    private func setPageMode() {
        navigationBar.topItem?.title = pageMode.description
    }
    
    private func setTextFields() {
        productNameTextField.placeholder = ProductUIString.productName
        productNameTextField.addDoneButton()
        productNameTextField.tag = 0
        productNameTextField.delegate = self
        
        priceTextField.placeholder = ProductUIString.productPrice
        priceTextField.addDoneButton()
        priceTextField.tag = 1
        
        discountedPriceTextField.placeholder = ProductUIString.discountedPrice
        discountedPriceTextField.addDoneButton()
        discountedPriceTextField.tag = 2
        
        stockTextField.placeholder = ProductUIString.productStock
        stockTextField.addDoneButton()
        stockTextField.tag = 3
        
        descriptionTextView.addDoneButton()
        descriptionTextView.tag = 4
    }
    
    private func setSegmentedControlTitle() {
        currencySegmentedControl.setTitle(Currency.krw.description, forSegmentAt: 0)
        currencySegmentedControl.setTitle(Currency.usd.description, forSegmentAt: 1)
    }
    
    private func setTextViewPlaceholder() {
        descriptionTextView.text = ProductUIString.defaultDescription
        descriptionTextView.textColor = .lightGray
    }
    
    private func addTextViewObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func registerProduct() {
        let apiService = MarketAPIService()
        guard let postProduct = makePostProduct() else {
            AlertManager.presentUnsuccessfulRegisterAlert(on: self)
            return
        }
        apiService.registerProduct(product: postProduct, images: productImages) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func makePostProduct() -> PostProduct? {
        guard isValidRequiredInputs else {
            return nil
        }
        guard let name = productNameTextField.text,
              let descriptions = descriptionTextView.text,
              let priceText = priceTextField.text,
              let price = Double(priceText),
              let currency = Currency(rawValue: currencySegmentedControl.selectedSegmentIndex) else {
            return nil
        }
        let discountedPrice = convertDiscountedPrice(discountedPriceTextField)
        let stock = convertStock(stockTextField)
      
        return .init(
            name: name,
            descriptions: descriptions,
            price: price,
            currency: currency.description,
            discountedPrice: discountedPrice,
            stock: stock,
            secret: "password"
        )
    }
    
    private func convertDiscountedPrice(_ textField: UITextField) -> Double? {
        guard textField.isValid,
              let text = textField.text else {
            return nil
        }
        return Double(text)
    }
    
    private func convertStock(_ textField: UITextField) -> Int? {
        guard textField.isValid,
              let text = textField.text else {
            return nil
        }
        return Int(text)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        var keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

// MARK: - UICollectionViewDataSource

extension ProductFormViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AddImageButtonCell.identifier,
                for: indexPath
            ) as! AddImageButtonCell
            
            cell.setup(delegate: self)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCell.identifier,
                for: indexPath
            ) as! ImageCell
            
            cell.configure(with: images[indexPath.row - 1], index: indexPath.row - 1, delegate: self)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductFormViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let sideLength = collectionView.frame.height
        let size = CGSize(width: sideLength, height: sideLength)
        
        return size
    }
}

// MARK: - AddImageCellDelegate

extension ProductFormViewController: AddImageCellDelegate {
    func addImageButtonTapped() {
        guard images.count < 5 else {
            AlertManager.presentExcessImagesAlert(on: self)
            return
        }
        self.present(self.imagePicker, animated: true, completion: nil)
    }
}

// MARK: - RemoveImageDelegate

extension ProductFormViewController: RemoveImageDelegate {
    func removeFromCollectionView(at index: Int) {
        self.collectionView.deleteItems(at: [IndexPath.init(row: index + 1, section: 0)])
        self.images.remove(at: index)
    }
}

//MARK: - UITextViewDelegate

extension ProductFormViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        textView.textColor = .black
    }
}

//MARK: - UITextFieldDelegate

extension ProductFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProductFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        let temporaryDirectoryPath = NSTemporaryDirectory() as String
        let fileName = ProcessInfo.processInfo.globallyUniqueString
        let productImage = ProductImage(
            name: temporaryDirectoryPath + fileName,
            type: .jpeg,
            image: image
        )
        
        images.append(image)
        productImages.append(productImage)
        dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
}

// MARK: - IdentifiableView

extension ProductFormViewController: IdentifiableView {}
