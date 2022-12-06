//
//  AddProductViewController.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/23.
//

import UIKit

final class AddProductViewController: UIViewController {
    private var imageCellIdentifiers: [Int] = [0]
    private let defaultIdentifier: Set<Int> = [0, 1, 2, 3, 4]
    private var navigationBarHeight: CGFloat = .zero
    
    private let backgroundScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var backView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return picker
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
        textView.textColor = .systemGray3
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.delegate = self
        return textView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    private var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureSubViews()
        configureHierarchy()
        configureDataSource()
        configureNavigationBar()
        addTarget()
        setKeyboardDoneButton()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "상품등록"
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
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
        if imageCellIdentifiers.count == 1 {
            showAlert(message: "이미지를 추가해 주세요.")
            return
        }
        
        if !checkCanAddProduct() {
            showAlert(message: "입력값이 잘못되었습니다.")
            return
        }
        
        showAlert(message: "등록 성공!")
    }
    
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            if alert.message == "등록 성공!" { self.dismiss(animated: true) }
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
            
            backView.heightAnchor.constraint(equalTo: backgroundScrollView.frameLayoutGuide.heightAnchor),
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

extension AddProductViewController {
    private func createLayout() -> UICollectionViewLayout {
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
    
    private func configureHierarchy() {
        imageCollectionView.collectionViewLayout = createLayout()
        imageCollectionView.delegate = self
    }
    
    private func configureDataSource() {
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
        
        snapshot.appendSections([0])
        snapshot.appendItems([0])
        
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
            nameTextField.layer.borderWidth = 1.0
            nameTextField.layer.borderColor = UIColor.systemRed.cgColor
            nameTextField.layer.cornerRadius = 5
        } else {
            nameTextField.layer.borderWidth = 0.0
        }
        
        if let textCount = descriptionTextView.text?.count,
           !((10...1000) ~= textCount) {
            descriptionTextView.layer.borderWidth = 1.0
            descriptionTextView.layer.borderColor = UIColor.systemRed.cgColor
            descriptionTextView.layer.cornerRadius = 5
        } else {
            descriptionTextView.layer.borderWidth = 0.0
        }
        
        if let price = Double(priceTextField.text ?? ""),
           !price.isZero {
            priceTextField.layer.borderWidth = 0.0
        } else {
            priceTextField.layer.borderWidth = 1.0
            priceTextField.layer.borderColor = UIColor.systemRed.cgColor
            priceTextField.layer.cornerRadius = 5
        }
        
        return [nameTextField, priceTextField, descriptionTextView].filter { $0.layer.borderWidth == 0 }.count == 3
    }
    
    func setNavigationBarHeight() {
        if navigationBarHeight.isZero {
            navigationBarHeight = -(backgroundScrollView.contentOffset.y)
        }
    }
    
    func setKeyboardDoneButton() {
        let keyboardBar = UIToolbar()
        keyboardBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(tapKeyboardDoneButton))
        keyboardBar.items = [button]
        [nameTextField, priceTextField, discountedPriceTextField, stockTextField].forEach {
            $0.inputAccessoryView = keyboardBar
        }
        descriptionTextView.inputAccessoryView = keyboardBar
    }
    
    @objc func tapKeyboardDoneButton(_ sender: Any) {
        self.view.endEditing(true)
    }
}

extension AddProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setNavigationBarHeight()
        view.endEditing(true)
        guard let cell = imageCollectionView.cellForItem(at: indexPath) as? ImageCell else { return }
        
        if cell.isGetImage {
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
              lastCell.isGetImage,
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
        
        checkCanAddProduct()
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
        checkCanAddProduct()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
