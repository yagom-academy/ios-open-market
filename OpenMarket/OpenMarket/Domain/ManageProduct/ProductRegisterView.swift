import Foundation
import UIKit

class ProductRegisterView: UIStackView {
    enum Section: Int {
        case image
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>!

    func setImages(images: [UIImage]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
        snapshot.appendSections([.image])
        snapshot.appendItems(images, toSection: .image)
        self.dataSource.apply(snapshot)
        guard let headerView = imageCollectionView.supplementaryView(
            forElementKind: "header",
            at: IndexPath(item: 0, section: 0)
        ) as? AddImageHeaderView else {
            return
        }
        headerView.modifyButtonTitle(for: images.count)
    }

    private lazy var imageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createImageGridLayout()
            )
        return collectionView
    }()

    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.borderStyle = .roundedRect
        textField.font = .preferredFont(forTextStyle: .subheadline)
        textField.layer.borderColor = UIColor.systemGray.cgColor
        return textField
    }()

    private let priceStackView = UIStackView()

    lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.borderStyle = .roundedRect
        textField.font = .preferredFont(forTextStyle: .subheadline)
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.keyboardType = .decimalPad
        return textField
    }()

    lazy var currencySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(
            items: [Currency.KRW.rawValue, Currency.USD.rawValue])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    lazy var discountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인금액"
        textField.borderStyle = .roundedRect
        textField.font = .preferredFont(forTextStyle: .subheadline)
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.keyboardType = .decimalPad
        return textField
    }()

    lazy var stockTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.borderStyle = .roundedRect
        textField.font = .preferredFont(forTextStyle: .subheadline)
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.keyboardType = .numberPad
        return textField
    }()

    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .systemGray
        textView.text = "상품설명을 작성해 주세요.(최대 1000글자)"
        textView.font = .preferredFont(forTextStyle: .footnote)
        textView.isScrollEnabled = false
        return textView
    }()

    private let tapGestureRecognizer = UITapGestureRecognizer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureStackView()
        configureDataSource()
        configureConstraint()
        configureGestureRecognizer()
    }

    required init(coder: NSCoder) {
        fatalError()
    }
}

// MARK: Gesture Recognizer
extension ProductRegisterView {
    private func configureGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }

    @objc func dismissKeyBoard() {
        self.endEditing(true)
    }
}

// MARK: Stack View Configuration
extension ProductRegisterView {
    private func configureStackView() {
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fill
        self.spacing = 8
    }

    private func configureHierarchy() {
        self.addArrangedSubview(imageCollectionView)
        self.addArrangedSubview(nameTextField)
        self.addArrangedSubview(priceStackView)
        configurePriceStackView()
        self.addArrangedSubview(discountTextField)
        self.addArrangedSubview(stockTextField)
        self.addArrangedSubview(descriptionTextView)
    }

    private func configurePriceStackView() {
        priceStackView.axis = .horizontal
        priceStackView.alignment = .fill
        priceStackView.distribution = .fill
        priceStackView.spacing = 8
        priceStackView.addArrangedSubview(priceTextField)
        priceStackView.addArrangedSubview(currencySegmentedControl)
    }

    private func configureConstraint() {
        configureCollectionViewConstraint()
        self.descriptionTextView.setContentHuggingPriority(.init(rawValue: 0), for: .vertical)
    }
}

// MARK: Collection View Configuration
extension ProductRegisterView {
    private func createImageGridLayout() -> UICollectionViewLayout {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.35),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.35),
            heightDimension: .fractionalHeight(1.0)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 130, bottom: 0, trailing: 0)
        section.interGroupSpacing = 10
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .absolute(120),
            heightDimension: .absolute(120)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: "header", alignment: .leading
        )

        sectionHeader.extendsBoundary = false
        sectionHeader.pinToVisibleBounds = false
        section.supplementariesFollowContentInsets = false
        section.boundarySupplementaryItems = [sectionHeader]

        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: configuration)

        return layout
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView
            .CellRegistration<ProductImageCell, UIImage> { cell, indexPath, identifier in
                cell.configure(image: identifier)
            }

        let headerRegistration = UICollectionView
            .SupplementaryRegistration<AddImageHeaderView>(
                elementKind: "header"
            ) { supplementaryView, elementKind, indexPath in
        }

        dataSource = UICollectionViewDiffableDataSource<Section, UIImage>(
            collectionView: imageCollectionView
        ) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: UIImage
        ) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: identifier
            )
        }

        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.imageCollectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: index
            )
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
        snapshot.appendSections([.image])
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func configureCollectionViewConstraint() {
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageCollectionView.heightAnchor.constraint(equalToConstant: 140),
            imageCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

// MARK: Set Delegate
extension ProductRegisterView {
    func setCollectionViewDelegate(delegate: UICollectionViewDelegate) {
        imageCollectionView.delegate = delegate
    }

    func setTextFieldDelegate(delegate: UITextFieldDelegate) {
        nameTextField.delegate = delegate
        priceTextField.delegate = delegate
        discountTextField.delegate = delegate
        stockTextField.delegate = delegate
    }

    func setTextViewDelegate(delegate: UITextViewDelegate) {
        descriptionTextView.delegate = delegate
    }
}
