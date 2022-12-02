//
//  AddProductViewController.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/23.
//

import UIKit

final class AddProductViewController: UIViewController {
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
        return textField
    }()
    
    private let discountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인금액"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let stockTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.borderStyle = .roundedRect
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
        var stackView = UIStackView(arrangedSubviews: [nameTextField, priceStackView, discountedPriceTextField, stockTextField])
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureSubViews()
        configureHierarchy()
        configureDataSource()
        configureNavigationBar()
        addTarget()
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
        dismiss(animated: true)
    }
    
    private func configureSubViews() {
        view.addSubview(imageCollectionView)
        view.addSubview(productStackView)
        view.addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            
            productStackView.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: 10),
            productStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            productStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            segmentedControl.widthAnchor.constraint(equalToConstant: 90),
            
            descriptionTextView.topAnchor.constraint(equalTo: productStackView.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
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
        section.orthogonalScrollingBehavior = .groupPaging
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension AddProductViewController {
    private func configureHierarchy() {
        imageCollectionView.collectionViewLayout = createLayout()
        view.addSubview(imageCollectionView)
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
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        snapshot.appendItems([0])
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func addImageForCell(indexPath: IndexPath) {
        guard let cell = imageCollectionView.cellForItem(at: indexPath) as? ImageCell else { return }
        cell.updateImage(image: UIImage(systemName: "signature"))
    }
}

extension AddProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        addImageForCell(indexPath: indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension AddProductViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.text == "상세정보 입력" {
            descriptionTextView.text = nil
            descriptionTextView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            descriptionTextView.text = "상세정보 입력"
            descriptionTextView.textColor = .systemGray3
            }
    }
}
