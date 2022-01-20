//
//  AddProductViewController.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/20.
//

import UIKit

class AddProductViewController: UIViewController {
    private typealias ImageID = Int
    private lazy var imageCollectionView = makeCollectionView()
    private lazy var dataSource = makeDatasource()
    private lazy var snapShot = NSDiffableDataSourceSnapshot<Int, ImageID>()

    private lazy var textFieldStackView = UIStackView()
    private lazy var nameTextField = CornerCurvedTextField()
    private lazy var priceStackView = UIStackView()
    private lazy var priceTextField = CornerCurvedTextField()
    private lazy var currencySegmentedControl = CornerCurvedSegmentedControl()
    private lazy var discountTextField = CornerCurvedTextField()
    private lazy var stockTextField = CornerCurvedTextField()
    private lazy var descriptionTextView = UITextView()
    private var images = [UIImage]()


    required init?(coder: NSCoder) {
        fatalError()
    }
    init() {
        super.init(nibName: nil, bundle: nil)
        imageCollectionView.dataSource = dataSource
        snapShot.appendSections([0])
        configure()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        images.append(UIImage(named: "macBook")!)
        images.append(UIImage(named: "macBook")!)
        images.append(UIImage(named: "macBook")!)
        images.append(UIImage(named: "macBook")!)
        images.append(UIImage(named: "macBook")!)
        snapShot.appendItems(images.enumerated().map { $0.offset })
        dataSource.apply(snapShot)
//        print(imageCollectionView.backgroundColor)
    }

    private func makeCollectionView() -> UICollectionView {
        UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
    }

    private func makeDatasource() -> UICollectionViewDiffableDataSource<Int, ImageID> {
        let cellRegistration = UICollectionView.CellRegistration<ImageCollectionViewCell, ImageID> { (cell, indexPath, image) in
            cell.imageView.image = self.images[indexPath.item]
        }
        dataSource = UICollectionViewDiffableDataSource<Int, ImageID>(collectionView: imageCollectionView) { (collectionView, indexPath, imageID) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: imageID)
        }
        return dataSource
    }

    private func configure() {
        view.backgroundColor = .white

        // navi bar
        title = "상품등록"

        let closeButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeButtonDidTap))
        navigationItem.leftBarButtonItem = closeButton

        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonDidTap))
        navigationItem.rightBarButtonItem = doneButton

        navigationController?.navigationBar.backgroundColor = .opaqueSeparator

        // Contents
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        
        //  Collection view
        stackView.addArrangedSubview(imageCollectionView)
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        imageCollectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        imageCollectionView.heightAnchor.constraint(equalTo: imageCollectionView.widthAnchor, multiplier: 0.65)
        ])
        imageCollectionView.isScrollEnabled = false
        imageCollectionView.backgroundColor = .white

        //  Text Fields
        stackView.addArrangedSubview(textFieldStackView)
        textFieldStackView.axis = .vertical
        textFieldStackView.spacing = 7

        textFieldStackView.addArrangedSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        nameTextField.makeBeautiful()
        nameTextField.placeholder = "상품명"
        
        textFieldStackView.addArrangedSubview(priceStackView)
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        priceStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        priceStackView.axis = .horizontal
        priceStackView.spacing = 7
        priceStackView.addArrangedSubview(priceTextField)
        priceStackView.addArrangedSubview(currencySegmentedControl)
        priceTextField.makeBeautiful()
        priceTextField.placeholder = "상품가격"
        
        currencySegmentedControl.makeBeautiful()
        currencySegmentedControl.insertSegment(withTitle: "\(Currency.KRW)", at: 0, animated: false)
        currencySegmentedControl.insertSegment(withTitle: "\(Currency.USD)", at: 1, animated: false)
        currencySegmentedControl.selectedSegmentIndex = 0
        currencySegmentedControl.backgroundColor = .systemGray5
        //add seg Action
        
        textFieldStackView.addArrangedSubview(discountTextField)
        discountTextField.translatesAutoresizingMaskIntoConstraints = false
        discountTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        discountTextField.makeBeautiful()
        discountTextField.placeholder = "할인금액"

        textFieldStackView.addArrangedSubview(stockTextField)
        stockTextField.translatesAutoresizingMaskIntoConstraints = false
        stockTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        stockTextField.makeBeautiful()
        stockTextField.placeholder = "재고수량"

        //  Text View
        stackView.addArrangedSubview(descriptionTextView)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTextView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])

        descriptionTextView.allowsEditingTextAttributes = true
        descriptionTextView.isScrollEnabled = true
    }

    @objc
    func closeButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc
    func doneButtonDidTap() {
        (print("POST")) //POST actions..+ reload collectionView(?)
        self.dismiss(animated: true, completion: nil)
    }



    func configureLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
