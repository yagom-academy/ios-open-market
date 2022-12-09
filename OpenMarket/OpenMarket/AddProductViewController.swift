//
//  AddProductViewController.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/23.
//

import UIKit

final class AddProductViewController: UIViewController, ProductManagingViewController {
    private var imageCellIdentifiers: [Int] = [0]
    private let defaultIdentifier: Set<Int> = [0, 1, 2, 3, 4]
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
    
    private let imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        return picker
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
        textView.textColor = .systemGray3
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        return textView
    }()
    
    init(_ networkManager: NetworkManager) {
        self.networkManager = networkManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        configureSubViews()
        configureCollectionView()
        configureDataSource()
        configureSnapshot()
        configureDelegate()
        configureNavigationBar(title: "상품등록")
        addTarget()
        setKeyboardDoneButton()
    }
    
    func configureDelegate() {
        [nameTextField, priceTextField, discountedPriceTextField, stockTextField].forEach { $0.delegate = self }
        imageCollectionView.delegate = self
        descriptionTextView.delegate = self
        imagePicker.delegate = self
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
        guard imageCellIdentifiers.count != 1 else {
            showAlert(message: "이미지를 추가해 주세요.")
            return
        }
        
        guard checkCanRequest() else {
            showAlert(message: "입력값이 잘못되었습니다.")
            return
        }
        
        postProductData()
    }
    
    private func postProductData() {
        guard let request = makeProductAddRequest() else { return }
        
        networkManager.postData(from: request) { result in
            switch result {
            case .success(let data):
                guard let product = JSONDecoder.decode(DetailProduct.self, from: data)
                else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(title: "등록 성공!", message: product.name) {
                        self?.dismiss(animated: true)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func makeNewProductData() -> Data? {
        guard let name = nameTextField.text,
              let description = descriptionTextView.text,
              let price = Double(priceTextField.text ?? ""),
              let currency = Currency.allCases[valid: segmentedControl.selectedSegmentIndex],
              let discountedPriceText = discountedPriceTextField.text,
              let stockText = stockTextField.text
        else { return nil }
        
        let discountedPrice = Double(discountedPriceText) ?? 0
        let stock = Int(stockText) ?? 0
        let newProduct = SendingProduct(name: name,
                                        description: description,
                                        price: price,
                                        discountedPrice: discountedPrice,
                                        currency: currency,
                                        stock: stock,
                                        secret: "sth4w4p3knfsxqgx")
        
        return JSONEncoder.encode(from: newProduct)
    }
    
    private func makeImageData() -> Data? {
        var data: Data = Data()
        for item in 0..<imageCellIdentifiers.count {
            guard let cell = imageCollectionView.cellForItem(at: IndexPath(item: item, section: 0)) as? ImageCell,
                  let imageData = cell.productImageData()
            else { break }
            data.append(imageData)
        }
        return data
    }
    
    private func makeProductAddRequest() -> URLRequest? {
        guard let params = makeNewProductData(),
              let images = makeImageData()
        else { return nil }
        var multipartFormData: MultipartFormData = MultipartFormData()
        multipartFormData.appendHeader(key: "identifier", value: "c598a7e9-6941-11ed-a917-8dbc932b3fe4")
        multipartFormData.appendBody(name: "params", contentType: "application/json", data: params)
        multipartFormData.appendBody(name: "images", fileName: "image.jpeg", contentType: "image/jpeg", data: images)
        
        let request = ProductAddRequest(from: multipartFormData).request
        
        return request
    }
}

extension AddProductViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ImageCell, Int> { (cell, indexPath, identifier) in
            cell.contentView.backgroundColor = .systemGray3
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
        
        snapshot.appendSections([0])
        snapshot.appendItems([0])
        
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

extension AddProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setNavigationBarHeight()
        view.endEditing(true)
        guard let cell = imageCollectionView.cellForItem(at: indexPath) as? ImageCell else { return }
        
        if cell.isNotEmpty {
            let removedIndex = imageCellIdentifiers.remove(at: indexPath.item)
            snapshot.deleteItems([removedIndex])
            dataSource.apply(snapshot, animatingDifferences: true) { [weak cell, weak self] in
                cell?.resetCell()
                self?.addNewCell()
            }
        } else if snapshot.numberOfItems(inSection: .zero) <= 5 {
            present(imagePicker, animated: true)
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let newImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        let numberOfCells = imageCollectionView.numberOfItems(inSection: 0)
        let cellIndex = IndexPath(item: numberOfCells - 1, section: 0)
        
        addImageForCell(indexPath: cellIndex, image: newImage)
        picker.dismiss(animated: true, completion: nil)
        
        addNewCell()
    }
    
    private func addNewCell() {
        let lastIndex = IndexPath(item: imageCellIdentifiers.count - 1, section: 0)
        guard let lastCell = imageCollectionView.cellForItem(at: lastIndex) as? ImageCell,
              lastCell.isNotEmpty,
              let newCellIdentifier = defaultIdentifier.subtracting(imageCellIdentifiers).first else { return }
        imageCellIdentifiers.append(newCellIdentifier)
        snapshot.appendItems([newCellIdentifier])
        dataSource.apply(snapshot, animatingDifferences: true)
        imageCollectionView.scrollToItem(at: lastIndex, at: .left, animated: true)
    }
}

extension AddProductViewController: UITextViewDelegate {
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

extension AddProductViewController: UITextFieldDelegate {
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
