//
//  UpdateProductViewController.swift
//  OpenMarket
//
//  Created by papri, Tiana on 18/05/2022.
//

import UIKit

class UpdateProductViewController: UIViewController {
    enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
        case image
        case text
        
        var description: String {
            switch self {
            case .image: return "Image"
            case .text: return "Text"
            }
        }
    }
    
    private var productInput = ProductInput()
    private var product: ProductDetail?
    private let imagePicker = UIImagePickerController()
    private var images: [UIImage] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView?.reloadData()
            }
        }
    }
    private var collectionView: UICollectionView?
    private var collectionViewLayout: UICollectionViewLayout?
    private var bottomConstraint: NSLayoutConstraint?
    
    lazy var completionHandler: (Result<Data, NetworkError>) -> Void = { data in
        switch data {
        case .success(_):
            DispatchQueue.main.async { [weak self] in
                self?.dismiss(animated: true)
            }
        case .failure(_):
            let alert = Alert().showWarning(title: "경고", message: "실패했습니다", completionHandler: nil)
            DispatchQueue.main.async { [weak self] in
                self?.present(alert, animated: true)
            }
            return
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(product: ProductDetail) {
        self.init()
        self.product = product
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
        
        if let product = product {
            product.images.forEach { image in
                DataProvider.shared.fetchImage(urlString: image.url) { [weak self] image in
                    self?.images.append(image)
                }
            }
        }
        collectionViewLayout = createLayout()
        
        configureHierarchy(collectionViewLayout: collectionViewLayout)
        registerCell()
        setUpCollectionView()
        
        setUpImagePicker()
        
        registerNotification()
    }
}

extension UpdateProductViewController {
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardBounds = notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as? NSValue else { return }

        bottomConstraint?.constant = -keyboardBounds.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        bottomConstraint?.constant = .zero
    }
    
}

extension UpdateProductViewController {
    private func setUpNavigationItem() {
        navigationItem.title = product == nil ? "상품등록": "상품수정"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(touchUpDoneButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(touchUpCancelButton))
    }
    
    @objc private func touchUpDoneButton() {
        if images.count == 0 {
            let alertController = Alert().showWarning(title: "이미지를 1개 이상 선택하세요.")
            present(alertController, animated: true)
            return
        }
        
        productInput.convertDescription()
        
        if let product = product {
            DataSender.shared.patchProductData(prductIdentifier: product.identifier, productInput: productInput.getProductInput(), completionHandler: completionHandler)
            return
        }
        DataSender.shared.postProductData(images: images, productInput: productInput.getProductInput(), completionHandler: completionHandler)
    }
    
    @objc private func touchUpCancelButton() {
        dismiss(animated: true)
    }
}

extension UpdateProductViewController {
    private func setUpCollectionView() {
        collectionView?.dataSource = self
        collectionView?.delegate = self
    }
    
    private func registerCell() {
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView?.register(TextCell.self, forCellWithReuseIdentifier: "TextCell")
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "EmptyCell")
    }
    
    private func configureHierarchy(collectionViewLayout: UICollectionViewLayout?) {
        guard let collectionViewLayout = collectionViewLayout else { return }
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        guard let collectionView = collectionView else { return }
    
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        layoutCollectionView()
    }
    
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            let section: NSCollectionLayoutSection
            
            if sectionKind == .image {
                let itemContentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalWidth(0.4))
                section = NSCollectionLayoutSection.setUpSection(itemContentInsets: itemContentInsets, groupSize: groupSize, orthogonalScrollingBehavior: .continuous)
            } else if sectionKind == .text {
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.45))
                section = NSCollectionLayoutSection.setUpSection(groupSize: groupSize)
            } else {
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                section = NSCollectionLayoutSection.setUpSection(groupSize: groupSize)
            }
            
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    private func layoutCollectionView() {
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.isScrollEnabled = false
        
        bottomConstraint = collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        NSLayoutConstraint.activate([
            collectionView?.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomConstraint,
        ].compactMap { $0 })
    }
}

extension UpdateProductViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if product == nil, images.count == 5 {
                return 5
            }
            let itemCount = product == nil ? images.count + 1 : images.count
            return itemCount
        } else if section == 1 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath)
            }
            
            if let _ = product {
                cell.hidePlusButton()
                cell.setImageView(with: images[indexPath.row])
                return cell
            }
            
            if images.count != indexPath.row {
                cell.hidePlusButton()
                guard let image = images[safe: indexPath.row] else {
                    return collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath)
                }
                cell.setImageView(with: image)
                return cell
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as? TextCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath)
            }
            
            if let product = product {
                cell.setElement(name: product.name,
                                price: product.price,
                                bargainPrice: product.price - product.bargainPrice,
                                stock: product.stock,
                                currency: product.currency,
                                description: product.description)
            }
            cell.delegate = self
            cell.setUpDelegate()

            return cell
        }
    }
}

extension UpdateProductViewController: TextCellDelegate {
    func observeSegmentIndex(value: String) {
        productInput.setCurrency(with: value)
    }
}

extension UpdateProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageCell else { return }
        if !cell.isPlusButtonHidden {
            present(imagePicker, animated: true)
        }
    }
}

extension UpdateProductViewController {
    private func setUpImagePicker() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
}

extension UpdateProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        
        if let newImage = newImage {
            images.append(newImage)
        }
        
        picker.dismiss(animated: true)
    }
}

extension UpdateProductViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.placeholder {
        case "상품명":
            productInput.setName(with: textField.text)
        case "상품가격":
            productInput.setPrice(with: textField.text)
        case "할인금액":
            productInput.setDiscountedPrice(with: textField.text)
        case "재고수량":
            productInput.setStock(with: textField.text)
        default:
            break
        }
    }
}

extension UpdateProductViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        productInput.setDescriptions(with: textView.text)
    }
}
