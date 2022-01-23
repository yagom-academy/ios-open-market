import UIKit

class ProductRegistrationViewController: UIViewController, UINavigationControllerDelegate {
    private let imagePickerController = UIImagePickerController()
    private var images = [UIImage]()
    private var isModifying: Bool?
    private var productInformation: Product?
    private var networkTask: NetworkTask?
    private var jsonParser: JSONParser?
    private var completionHandler: (() -> Void)?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var discountedPriceTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!
    
    convenience init?(
        coder: NSCoder,
        isModifying: Bool,
        networkTask: NetworkTask,
        jsonParser: JSONParser,
        completionHandler: (() -> Void)?
    ) {
        self.init(coder: coder)
        self.isModifying = isModifying
        self.networkTask = networkTask
        self.jsonParser = jsonParser
        self.completionHandler = completionHandler
    }
    
    convenience init?(
        coder: NSCoder,
        isModifying: Bool,
        productInformation: Product,
        networkTask: NetworkTask,
        jsonParser: JSONParser,
        completionHandler: (() -> Void)?
    ) {
        self.init(coder: coder)
        self.isModifying = isModifying
        self.networkTask = networkTask
        self.jsonParser = jsonParser
        self.completionHandler = completionHandler
        self.productInformation = productInformation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesCollectionView.dataSource = self
        productNameTextField.delegate = self
        setUpImagePicker()
        setupNavigationBar()
        setupTextView()
        loadProductInformation()
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
    
    @objc private func registerProduct() {
        let identifier = "2836ea8c-7215-11ec-abfa-378889d9906f"
        let secret = "-3CSKv$cyHsK_@Wk"
        let writtenSalesInformation = makeSalesInformation(
            secret: secret,
            maximumDescriptionsLimit: 1000,
            minimumDescriptionsLimit: 10,
            maximumNameLimit: 100,
            minimumNameLimit: 3
        )
        let salesInformation: NetworkTask.SalesInformation
        switch writtenSalesInformation {
        case .success(let result):
            salesInformation = result
        case .failure(let error):
            showAlert(title: error.errorDescription, message: nil)
            return
        }
        
        var count = 0
        var imageDatas = [String: Data]()
        for image in images {
            let compressionQuality: CGFloat = 0.8
            let fileName = "\(count).jpeg"
            var originalImage = image
            var imageData = originalImage.jpegData(compressionQuality: compressionQuality)
            while let bytes = imageData?.count, bytes >= 300 * 1000 {
                let multiplier: CGFloat = 0.8
                originalImage = originalImage.resize(multiplier: multiplier)
                imageData = originalImage.jpegData(compressionQuality: compressionQuality)
            }
            count += 1
            imageDatas[fileName] = imageData
        }
        
        networkTask?.requestProductRegistration(
            identifier: identifier,
            salesInformation: salesInformation,
            images: imageDatas
        ) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: self.completionHandler)
                }
            case .failure(let error):
                self.showAlert(title: "등록 실패", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func modifyProduct() {
        let identifier = "2836ea8c-7215-11ec-abfa-378889d9906f"
        let secret = "-3CSKv$cyHsK_@Wk"
        let writtenSalesInformation = modifiySalesInformation(
            secret: secret,
            maximumDescriptionsLimit: 1000,
            minimumDescriptionsLimit: 10,
            maximumNameLimit: 100,
            minimumNameLimit: 3
        )
        let modificationInformation: NetworkTask.ModificationInformation
        switch writtenSalesInformation {
        case .success(let result):
            modificationInformation = result
        case .failure(let error):
            showAlert(title: error.errorDescription, message: nil)
            return
        }
        
        guard let productId = productInformation?.id else { return }
        networkTask?.requestProductModification(
            identifier: identifier,
            productId: productId,
            information: modificationInformation
        ) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: self.completionHandler)
                }
            case .failure(let error):
                self.showAlert(title: "수정 실패", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func dismissProductRegistration() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func presentImagePicker() {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        if let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            scrollView.contentInset.bottom = keyboardHeight
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        }
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(dismissProductRegistration)
        )
        if isModifying == .some(true) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .done,
                target: self,
                action: #selector(modifyProduct)
            )
            navigationItem.title = "상품수정"
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .done,
                target: self,
                action: #selector(registerProduct)
            )
            navigationItem.title = "상품등록"
        }
    }
    
    private func loadProductInformation() {
        guard let productInformation = productInformation else { return }
        productNameTextField.text = productInformation.name
        productPriceTextField.text = productInformation.price.description
        discountedPriceTextField.text = productInformation.discountedPrice.description
        stockTextField.text = productInformation.stock.description
        descriptionTextView.text = productInformation.description
        descriptionTextView.textColor = .label
        if productInformation.currency == .krw {
            currencySegmentedControl.selectedSegmentIndex = 0
        } else if productInformation.currency == .usd {
            currencySegmentedControl.selectedSegmentIndex = 1
        }
        productInformation.images?.forEach { image in
            guard let url = URL(string: image.url),
                  let imageData = try? Data(contentsOf: url),
                  let downloadedImage = UIImage(data: imageData) else { return }
            images.append(downloadedImage)
        }
    }
    
    private func setUpImagePicker() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
    }
    
    private func setupTextView() {
        descriptionTextView.delegate = self
        descriptionTextView.text = "상품설명"
        descriptionTextView.textColor = .placeholderText
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.borderColor = CGColor(
            srgbRed: 0.8,
            green: 0.8,
            blue: 0.8,
            alpha: 1.0
        )
    }
    
    private func makeSalesInformation(
        secret: String,
        maximumDescriptionsLimit: Int?,
        minimumDescriptionsLimit: Int?,
        maximumNameLimit: Int?,
        minimumNameLimit: Int?
    ) -> Result<NetworkTask.SalesInformation, ProductRegistrationError> {
        let discountedPrice = Decimal(string: discountedPriceTextField.text ?? "")
        let stock = UInt(stockTextField.text ?? "")
        
        let selectedSegmentIndex = currencySegmentedControl.selectedSegmentIndex
        let selectedSegmentTitle = currencySegmentedControl.titleForSegment(
            at: selectedSegmentIndex
        ) ?? ""
        if images.isEmpty {
            return .failure(.emptyImage)
        }
        guard let name = productNameTextField.text, name.isEmpty == false else {
            return .failure(.emptyName)
        }
        guard let price = Decimal(string: productPriceTextField.text ?? "") else {
            return .failure(.emptyPrice)
        }
        guard let currency = Currency(rawValue: selectedSegmentTitle) else {
            return .failure(.emptyCurrency)
        }
        guard let descriptions = descriptionTextView.text, descriptions != "상품설명" else {
            return .failure(.emptyDiscription)
        }
        
        if let error = inspectInput(
            price: price,
            discountedPrice: discountedPrice,
            nameCount: name.count,
            descriptionsCount: descriptions.count,
            maximumDescriptionsLimit: maximumDescriptionsLimit,
            minimumDescriptionsLimit: minimumDescriptionsLimit,
            maximumNameLimit: maximumNameLimit,
            minimumNameLimit: minimumNameLimit
        ) {
            return .failure(error)
        }
        
        let product = NetworkTask.SalesInformation(
            name: name,
            descriptions: descriptions,
            price: price,
            currency: currency,
            discountedPrice: discountedPrice,
            stock: stock,
            secret: secret)
        return .success(product)
    }
    
    private func modifiySalesInformation(
        secret: String,
        maximumDescriptionsLimit: Int?,
        minimumDescriptionsLimit: Int?,
        maximumNameLimit: Int?,
        minimumNameLimit: Int?
    ) -> Result<NetworkTask.ModificationInformation, ProductRegistrationError> {
        let discountedPrice = Decimal(string: discountedPriceTextField.text ?? "")
        let stock = UInt(stockTextField.text ?? "")
        
        let selectedSegmentIndex = currencySegmentedControl.selectedSegmentIndex
        let selectedSegmentTitle = currencySegmentedControl.titleForSegment(
            at: selectedSegmentIndex
        ) ?? ""
        guard let name = productNameTextField.text, name.isEmpty == false else {
            return .failure(.emptyName)
        }
        guard let price = Decimal(string: productPriceTextField.text ?? "") else {
            return .failure(.emptyPrice)
        }
        guard let currency = Currency(rawValue: selectedSegmentTitle) else {
            return .failure(.emptyCurrency)
        }
        guard let descriptions = descriptionTextView.text, descriptions != "상품설명" else {
            return .failure(.emptyDiscription)
        }
        
        if let error = inspectInput(
            price: price,
            discountedPrice: discountedPrice,
            nameCount: name.count,
            descriptionsCount: descriptions.count,
            maximumDescriptionsLimit: maximumDescriptionsLimit,
            minimumDescriptionsLimit: minimumDescriptionsLimit,
            maximumNameLimit: maximumNameLimit,
            minimumNameLimit: minimumNameLimit
        ) {
            return .failure(error)
        }
        
        let product = NetworkTask.ModificationInformation(
            name: name,
            descriptions: descriptions,
            thumbnailId: nil,
            price: price,
            currency: currency,
            discountedPrice: discountedPrice,
            stock: stock,
            secret: secret)
        return .success(product)
    }
    
    private func inspectInput(
        price: Decimal,
        discountedPrice: Decimal?,
        nameCount: Int,
        descriptionsCount: Int,
        maximumDescriptionsLimit: Int?,
        minimumDescriptionsLimit: Int?,
        maximumNameLimit: Int?,
        minimumNameLimit: Int?
    ) -> ProductRegistrationError? {
        if price.isSignMinus || discountedPrice?.isSignMinus == .some(true) {
            return .negativePrice
        }
        if let discountedPrice = discountedPrice, discountedPrice > price {
            return .maximumDiscountedPrice(price)
        }
        if let maximumDescriptionsLimit = maximumDescriptionsLimit,
           descriptionsCount > maximumDescriptionsLimit {
            return .maximumCharacterLimit(.description, maximumDescriptionsLimit)
        }
        if let minimumDescriptionsLimit = minimumDescriptionsLimit,
           descriptionsCount < minimumDescriptionsLimit {
            return .minimumCharacterLimit(.description, minimumDescriptionsLimit)
        }
        if let maximumNameLimit = maximumNameLimit,
           nameCount > maximumNameLimit {
            return .maximumCharacterLimit(.name, maximumNameLimit)
        }
        if let minimumNameLimit = minimumNameLimit,
           nameCount < minimumNameLimit {
            return .minimumCharacterLimit(.name, minimumNameLimit)
        }
        return nil
    }
    
    private func cropSquare(_ image: UIImage) -> UIImage? { // extension으로 옮기기
        let imageSize = image.size
        let shortLength = imageSize.width < imageSize.height ? imageSize.width : imageSize.height
        let origin = CGPoint(
            x: imageSize.width / 2 - shortLength / 2,
            y: imageSize.height / 2 - shortLength / 2
        )
        let size = CGSize(width: shortLength, height: shortLength)
        let square = CGRect(origin: origin, size: size)
        guard let squareImage = image.cgImage?.cropping(to: square) else {
            return nil
        }
        return UIImage(cgImage: squareImage, scale: 1.0, orientation: .up)
    }
    
    @IBAction func tapBackground(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension ProductRegistrationViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard var newImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        let isSquare = newImage.size.width == newImage.size.height
        if isSquare == false {
            if let squareImage = cropSquare(newImage) {
                newImage = squareImage
            }
        }
        images.append(newImage)
        imagesCollectionView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProductRegistrationViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if images.count < 5, isModifying == false {
            return 2
        } else {
            return 1
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if section == 0 {
            return images.count
        } else {
            return 1
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UICollectionViewCell.reuseIdentifier,
            for: indexPath
        )
        cell.contentView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        if indexPath.section == 0 {
            let image = images[indexPath.item]
            let imageView = UIImageView(frame: cell.contentView.frame)
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            cell.contentView.addSubview(imageView)
        } else {
            let button = UIButton(type: .system)
            let image = UIImage(systemName: "plus")
            button.setTitle(nil, for: .normal)
            button.setImage(image, for: .normal)
            button.addTarget(self, action: #selector(presentImagePicker), for: .touchUpInside)
            button.backgroundColor = .opaqueSeparator
            cell.contentView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                button.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                button.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                button.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        }
        return cell
    }
}

extension ProductRegistrationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "상품설명"
            textView.textColor = .placeholderText
        }
    }
}

extension ProductRegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == productNameTextField {
            productPriceTextField.becomeFirstResponder()
        }
        return false
    }
}
