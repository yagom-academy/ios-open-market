import Foundation
import UIKit

class ProductRegisterView: UIStackView {
    private var dataSource: UICollectionViewDiffableDataSource<Int, UIImage>!

    var imageList: [UIImage] = [] {
        didSet {
            var snapshot = NSDiffableDataSourceSnapshot<Int, UIImage>()
            snapshot.appendSections([1])
            snapshot.appendItems(imageList, toSection: 1)
            self.dataSource.apply(snapshot)
        }
    }

    lazy var imageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createImageGridLayout()
            )
        return collectionView
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.borderStyle = .roundedRect
        textField.font = .preferredFont(forTextStyle: .subheadline)
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.delegate = self
        return textField
    }()

    private let priceStackView = UIStackView()

    private lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.borderStyle = .roundedRect
        textField.font = .preferredFont(forTextStyle: .subheadline)
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.delegate = self
        return textField
    }()

    private lazy var currencySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["KRW", "USD"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    private lazy var discountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인금액"
        textField.borderStyle = .roundedRect
        textField.font = .preferredFont(forTextStyle: .subheadline)
        textField.layer.borderColor = UIColor.systemGray.cgColor
        return textField
    }()

    private lazy var stockTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.borderStyle = .roundedRect
        textField.font = .preferredFont(forTextStyle: .subheadline)
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.delegate = self
        return textField
    }()

    private lazy var descriptionTextView = UITextView()

    private let tapGestureRecognizer = UITapGestureRecognizer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureStackView()
        configureDataSource()
        configureConstraint()
        imageCollectionView.isScrollEnabled = false
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
    }
}

// MARK: Collection View Configuration
extension ProductRegisterView {
    private func createImageGridLayout() -> UICollectionViewLayout {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.38),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.orthogonalScrollingBehavior = .continuous

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    private func configureDataSource() {
        let cellRegistration =
            UICollectionView.CellRegistration<ProductImageCell, UIImage> { cell, indexPath, identifier in
                cell.configure(image: identifier)
            }
        dataSource = UICollectionViewDiffableDataSource<Int, UIImage>(
            collectionView: imageCollectionView
        ) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: UIImage
        ) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: identifier
            )
        }

        var snapshot = NSDiffableDataSourceSnapshot<Int, UIImage>()
        snapshot.appendSections([1])
        imageList.append(UIImage(named: "robot")!)
        imageList.append(UIImage(systemName: "plus")!)
        snapshot.appendItems(imageList, toSection: 1)
        print(11)
        self.dataSource.apply(snapshot)
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

// MARK: Text Field Delegate
extension ProductRegisterView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
