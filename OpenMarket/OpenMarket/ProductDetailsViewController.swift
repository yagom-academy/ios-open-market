//
//  ProductDetailsController.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/21.
//

import UIKit

protocol AddButtonPressedDelegate {
    func addButtonPressed()
}

final class ProductDetailsViewController: UIViewController {
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
    
    private var images: [UIImage] = []
    private var productImages: [ProductImage] = []
    private var keyHeight: CGFloat?
    weak var delegate: MarketViewController?
    
    init?(delegate: MarketViewController, coder: NSCoder) {
        self.delegate = delegate
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("실패")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupCollectionViewCells()
        setNavigationBar()
        setPlaceholders()
        setSegmentedControlTitle()
        setTextViewPlaceholder()
        addTextViewObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        productNameTextField.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
}

//MARK: - IBActions

extension ProductDetailsViewController {
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

extension ProductDetailsViewController {
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
        navigationBar.topItem?.title = "상품등록"
    }
    
    private func setPlaceholders() {
        productNameTextField.placeholder = "상품명"
        priceTextField.placeholder = "상품가격"
        discountedPriceTextField.placeholder = "할인금액"
        stockTextField.placeholder = "재고수량"
    }
    
    private func setSegmentedControlTitle() {
        currencySegmentedControl.setTitle("KRW", forSegmentAt: 0)
        currencySegmentedControl.setTitle("USD", forSegmentAt: 1)
    }
    
    private func setTextViewPlaceholder() {
        descriptionTextView.text = "제품 설명을 입력하세요."
        descriptionTextView.textColor = .lightGray
    }
    
    private func addTextViewObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func registerProduct() {
        let apiService = MarketAPIService()
        guard let postProduct = makePostProduct() else {
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
        guard productNameTextField.text != "",
              priceTextField.text != "",
              descriptionTextView.text != "제품 설명을 입력하세요." else {
                  return nil
              }
        guard let name = productNameTextField.text,
              let descriptions = descriptionTextView.text,
              let priceText = priceTextField.text,
              let price = Double(priceText),
              let currency = Currency(rawValue: currencySegmentedControl.selectedSegmentIndex) else {
            return nil
        }
        
        var discountedPrice: Double? = 0
        var stock: Int? = 0
        
        if let discountedPriceString = discountedPriceTextField.text,
           let stockString = stockTextField.text,
           discountedPriceString != "",
           stockString != "" {
            discountedPrice = Double(discountedPriceString)
            stock = Int(stockString)
        }
        
        let product = PostProduct(
            name: name,
            descriptions: descriptions,
            price: price,
            currency: currency.description,
            discountedPrice: discountedPrice,
            stock: stock,
            secret: "password"
        )
      
        return product
    }
    // https://stackoverflow.com/a/32583809
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

// MARK: - UICollectionViewDataSource

extension ProductDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageButtonCell.identifier, for: indexPath) as! AddImageButtonCell
            
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
            
            cell.configure(with: images[indexPath.row - 1])
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideLength = collectionView.frame.height
        let size = CGSize(width: sideLength, height: sideLength)
        
        return size
    }
}

// MARK: - AddImageCellDelegate

extension ProductDetailsViewController: AddImageCellDelegate {
    func addImagePressed(by cell: AddImageButtonCell) {
        guard images.count < 5 else {
            AlertManager.presentExcessImagesAlert(on: self)
            return
        }
        self.present(self.imagePicker, animated: true, completion: nil)
    }
}

//MARK: - UITextViewDelegate

extension ProductDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        textView.textColor = .black
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProductDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        let tmpPath = NSTemporaryDirectory() as String
        let fileName = ProcessInfo.processInfo.globallyUniqueString
        
        let productImage = ProductImage(name: tmpPath + fileName, type: .jpeg, image: image)
        
        images.append(image)
        productImages.append(productImage)
        
        dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
}
