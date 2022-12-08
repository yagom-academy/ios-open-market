//
//  EditProductViewController.swift
//  OpenMarket
//
//  Created by Wonbi on 2022/12/08.
//

import UIKit

class EditProductViewController: UIViewController {
    private let product: DetailProduct
    private var navigationBarHeight: CGFloat = .zero
    private let networkManager: NetworkManager
    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    private var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
    private let images: [UIImage]
    
    private let backgroundScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let backView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let leftButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "Cancel"
        return barButton
    }()
    
    private let rightButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "Done"
        return barButton
    }()
    
    private let imageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let discountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인금액"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let stockTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: Currency.allCases.compactMap { $0.rawValue })
        segmentedControl.selectedSegmentIndex = Currency.allCases.startIndex
        segmentedControl.backgroundColor = .systemGray6
        return segmentedControl
    }()
    
    private lazy var priceStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [priceTextField, segmentedControl])
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var productStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [nameTextField,
                                                       priceStackView,
                                                       discountedPriceTextField,
                                                       stockTextField])
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "상세정보 입력"
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.delegate = self
        return textView
    }()
    
    init(_ networkManager: NetworkManager, product: DetailProduct, images: [UIImage]) {
        self.product = product
        self.networkManager = networkManager
        self.images = images
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureSubViews()
        configureCollectionView()
        configureDataSource()
        configureSnapshot()
        configureNavigationBar()
        configureProductInfomation()
        addTarget()
        setKeyboardDoneButton()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "상품수정"
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func configureProductInfomation() {
        nameTextField.text = product.name
        priceTextField.text = fetchNumberText(from: product.price)
        segmentedControl.selectedSegmentIndex = product.currency.index
        discountedPriceTextField.text = fetchNumberText(from: product.discountedPrice)
        stockTextField.text = String(product.stock)
        descriptionTextView.text = product.description
    }
    
    private func fetchNumberText(from double: Double) -> String {
        let number = String(double)
        let syntax = number.components(separatedBy: ".")
        
        if let lastSyntax = Int(syntax[1]), lastSyntax.isZero {
            return syntax[0]
        }
        return number
    }
    
    private func addTarget() {
        leftButton.action = #selector(tapCancelButton)
        leftButton.target = self
        rightButton.action = #selector(tapDoneButton)
        rightButton.target = self
    }
    
    @objc private func tapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func tapDoneButton() {
        guard checkCanAddProduct() else {
            showAlert(message: "입력값이 잘못되었습니다.")
            return
        }
        
        patchEditProductData()
    }
    
    private func patchEditProductData() {
        guard let request = makeProductEditRequest() else { return }
        
        networkManager.fetchData(from: request, dataType: DetailProduct.self) { result in
            switch result {
            case .success(let product):
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(title: "수정 성공!", message: product.name) {
                        self?.dismiss(animated: true)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func makeEditProduct() -> EditProduct? {
        guard let name = nameTextField.text,
              let description = descriptionTextView.text,
              let price = Double(priceTextField.text ?? ""),
              let currency = Currency.allCases[valid: segmentedControl.selectedSegmentIndex],
              let discountedPriceText = discountedPriceTextField.text,
              let stockText = stockTextField.text,
              let thumnailID = imageCollectionView.indexPathsForSelectedItems?.first?.item
        else { return nil }
        
        let discountedPrice = Double(discountedPriceText) ?? 0
        let stock = Int(stockText) ?? 0
        let editedProduct = EditProduct(productID: product.id,
                                        secret: "sth4w4p3knfsxqgx",
                                        stock: stock,
                                        name: name,
                                        description: description,
                                        thumbnailID: thumnailID,
                                        discountedPrice: discountedPrice,
                                        price: price,
                                        currency: currency)
        
        return editedProduct
    }
    
    private func makeProductEditRequest() -> URLRequest? {
        guard let editProduct = makeEditProduct(),
              let request = ProductEditRequest(identifier: "c598a7e9-6941-11ed-a917-8dbc932b3fe4",
                                               editProduct: editProduct).request
        else { return nil }

        return request
    }
    
    private func showAlert(title: String? = nil, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            if let completion = completion {
                completion()
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func configureSubViews() {
        view.addSubview(backgroundScrollView)
        backgroundScrollView.addSubview(backView)
        backView.addSubview(imageCollectionView)
        backView.addSubview(productStackView)
        backView.addSubview(descriptionTextView)
        
        [nameTextField, priceTextField, discountedPriceTextField, stockTextField].forEach { $0.delegate = self }
        
        NSLayoutConstraint.activate([
            backgroundScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backView.topAnchor.constraint(equalTo: backgroundScrollView.contentLayoutGuide.topAnchor),
            backView.leadingAnchor.constraint(equalTo: backgroundScrollView.contentLayoutGuide.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: backgroundScrollView.contentLayoutGuide.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: backgroundScrollView.contentLayoutGuide.bottomAnchor),
            
            backView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            backView.widthAnchor.constraint(equalTo: backgroundScrollView.frameLayoutGuide.widthAnchor),
            
            imageCollectionView.topAnchor.constraint(equalTo: backView.topAnchor,
                                                     constant: 10),
            imageCollectionView.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalTo: backView.widthAnchor,
                                                        multiplier: 0.4),
            
            productStackView.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor,
                                                  constant: 10),
            productStackView.leadingAnchor.constraint(equalTo: backView.leadingAnchor,
                                                      constant: 10),
            productStackView.trailingAnchor.constraint(equalTo: backView.trailingAnchor,
                                                       constant: -10),
            segmentedControl.widthAnchor.constraint(equalToConstant: 90),
            
            descriptionTextView.topAnchor.constraint(equalTo: productStackView.bottomAnchor,
                                                     constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: backView.leadingAnchor,
                                                         constant: 10),
            descriptionTextView.trailingAnchor.constraint(equalTo: backView.trailingAnchor,
                                                          constant: -10),
            descriptionTextView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -10),
        ])
    }
}

extension EditProductViewController {
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let section: NSCollectionLayoutSection = {
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.4),
                    heightDimension: .fractionalHeight(1.0)
                ),
                subitem: item,
                count: 1
            )
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            
            return section
        }()
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureCollectionView() {
        imageCollectionView.collectionViewLayout = createCollectionViewLayout()
        imageCollectionView.delegate = self
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ImageCell, Int> { (cell, indexPath, identifier) in
            cell.updateImage(image: self.images[indexPath.item])
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: imageCollectionView) {(
            collectionView: UICollectionView,
            indexPath: IndexPath,
            identifier: Int) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: identifier)
        }
    }
    
    private func configureSnapshot() {
        let items = images.compactMap { images.firstIndex(of: $0) }
        
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func addImageForCell(indexPath: IndexPath, image: UIImage) {
        guard let cell = imageCollectionView.cellForItem(at: indexPath) as? ImageCell else { return }
        cell.updateImage(image: image)
    }
    
    @discardableResult
    private func checkCanAddProduct() -> Bool {
        if let nameCount = nameTextField.text?.count,
           !((3...100) ~= nameCount) {
            highlightTextBounds(nameTextField)
        } else {
            nameTextField.layer.borderWidth = .zero
        }
        
        if let textCount = descriptionTextView.text?.count,
           !((10...1000) ~= textCount) {
            highlightTextBounds(descriptionTextView)
        } else {
            descriptionTextView.layer.borderWidth = .zero
        }
        
        if let price = Double(priceTextField.text ?? ""),
           !price.isZero {
            priceTextField.layer.borderWidth = .zero
        } else {
            highlightTextBounds(priceTextField)
        }
        
        if let price = Double(priceTextField.text ?? ""),
           let discountPrice = Double(discountedPriceTextField.text ?? ""),
           discountPrice > price {
            highlightTextBounds(discountedPriceTextField)
        } else {
            discountedPriceTextField.layer.borderWidth = .zero
        }
        
        let components = [nameTextField, priceTextField, discountedPriceTextField, descriptionTextView]
        return components.filter { $0.layer.borderWidth == 0 }.count == 4
    }
    
    private func highlightTextBounds(_ view: UIView) {
        let highlightedBorderWidth: CGFloat = 1.0
        let cornerRadius: CGFloat = 5
        
        view.layer.borderWidth = highlightedBorderWidth
        view.layer.borderColor = UIColor.systemRed.cgColor
        view.layer.cornerRadius = cornerRadius
    }
    
    private func setNavigationBarHeight() {
        if navigationBarHeight.isZero {
            navigationBarHeight = -(backgroundScrollView.contentOffset.y)
        }
    }
    
    private func setKeyboardDoneButton() {
        let keyboardBar = UIToolbar()
        keyboardBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done",
                                     style: .plain,
                                     target: self,
                                     action: #selector(tapKeyboardDoneButton))
        keyboardBar.items = [button]
        [nameTextField, priceTextField, discountedPriceTextField, stockTextField].forEach {
            $0.inputAccessoryView = keyboardBar
        }
        descriptionTextView.inputAccessoryView = keyboardBar
    }
    
    @objc private func tapKeyboardDoneButton(_ sender: Any) {
        self.view.endEditing(true)
    }
}

extension EditProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        cell.layer.borderWidth = 3.0
        cell.layer.borderColor = UIColor.systemOrange.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        cell.layer.borderWidth = 0
    }
}

extension EditProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let newImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        let numberOfCells = imageCollectionView.numberOfItems(inSection: 0)
        let cellIndex = IndexPath(item: numberOfCells - 1, section: 0)
        
        addImageForCell(indexPath: cellIndex, image: newImage)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditProductViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        setNavigationBarHeight()
        let contentOffset = CGPoint(x: 0, y: productStackView.frame.maxY - navigationBarHeight)
        backgroundScrollView.setContentOffset(contentOffset, animated: true)
        
        descriptionTextView.layer.borderWidth = 0.0
        
        if descriptionTextView.text == "상세정보 입력" {
            descriptionTextView.text = nil
            descriptionTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let contentOffset = CGPoint(x: 0, y: -navigationBarHeight)
        backgroundScrollView.setContentOffset(contentOffset, animated: true)
        
        if descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            descriptionTextView.text = "상세정보 입력"
            descriptionTextView.textColor = .systemGray3
        }
        
        checkCanAddProduct()
    }
}

extension EditProductViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setNavigationBarHeight()
        let contentOffset = CGPoint(x: 0, y: imageCollectionView.frame.maxY - navigationBarHeight)
        backgroundScrollView.setContentOffset(contentOffset, animated: true)
        
        textField.layer.borderWidth = 0.0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let contentOffset = CGPoint(x: 0, y: -navigationBarHeight)
        backgroundScrollView.setContentOffset(contentOffset, animated: true)
        checkCanAddProduct()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
