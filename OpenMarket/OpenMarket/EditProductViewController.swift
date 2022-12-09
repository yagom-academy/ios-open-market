//
//  EditProductViewController.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/12/08.
//

import UIKit

final class EditProductViewController: UIViewController, ProductManagingViewController {
    private let product: DetailProduct
    private let images: [UIImage]
    var navigationBarHeight: CGFloat = .zero
    let networkManager: NetworkManager
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
    
    let backgroundScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let backView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let leftButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "Cancel"
        return barButton
    }()
    
    let rightButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "Done"
        return barButton
    }()
    
    let imageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    let discountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인금액"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    let stockTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: Currency.allCases.compactMap { $0.rawValue })
        segmentedControl.selectedSegmentIndex = Currency.allCases.startIndex
        segmentedControl.backgroundColor = .systemGray6
        return segmentedControl
    }()
    
    let priceStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    let productStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "상세정보 입력"
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
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
        configureDelegate()
        configureNavigationBar(title: "상품수정")
        configureProductInfomation()
        addTarget()
        setKeyboardDoneButton()
    }
    
    func configureDelegate() {
        [nameTextField, priceTextField, discountedPriceTextField, stockTextField].forEach { $0.delegate = self }
        imageCollectionView.delegate = self
        descriptionTextView.delegate = self
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
    
    func addTarget() {
        leftButton.action = #selector(tapCancelButton)
        leftButton.target = self
        rightButton.action = #selector(tapDoneButton)
        rightButton.target = self
    }
    
    @objc func tapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc func tapDoneButton() {
        guard checkCanRequest() else {
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
    
    private func makeEditProduct() -> SendingProduct? {
        guard let name = nameTextField.text,
              let description = descriptionTextView.text,
              let price = Double(priceTextField.text ?? ""),
              let currency = Currency.allCases[valid: segmentedControl.selectedSegmentIndex],
              let discountedPriceText = discountedPriceTextField.text,
              let stockText = stockTextField.text
        else { return nil }
        
        let discountedPrice = Double(discountedPriceText) ?? 0
        let stock = Int(stockText) ?? 0
        let thumnailID = imageCollectionView.indexPathsForSelectedItems?.first?.item
        let editedProduct = SendingProduct(productID: product.id,
                                           name: name,
                                           description: description,
                                           thumbnailID: thumnailID,
                                           price: price,
                                           discountedPrice: discountedPrice,
                                           currency: currency,
                                           stock: stock,
                                           secret: "sth4w4p3knfsxqgx")
        return editedProduct
    }
    
    private func makeProductEditRequest() -> URLRequest? {
        guard let editProduct = makeEditProduct(),
              let request = ProductEditRequest(identifier: "c598a7e9-6941-11ed-a917-8dbc932b3fe4",
                                               editProduct: editProduct).request
        else { return nil }
        
        return request
    }
}

extension EditProductViewController {
    func configureDataSource() {
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
    
    func configureSnapshot() {
        let items = images.compactMap { images.firstIndex(of: $0) }
        
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func setKeyboardDoneButton() {
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
        
        checkCanRequest()
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
        checkCanRequest()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
