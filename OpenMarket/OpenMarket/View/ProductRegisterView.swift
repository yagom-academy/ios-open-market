import Foundation
import UIKit

class ProductRegisterView: UIStackView {
    enum Section: Int {
        case image
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>!

    var imageList: [UIImage] = [] {
        didSet {
            var snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
            snapshot.appendSections([.image])
            snapshot.appendItems(imageList, toSection: .image)
            self.dataSource.apply(snapshot)
            guard let cell = imageCollectionView.cellForItem(
                at: IndexPath(item: 0, section: 0)
            ) as? ProductImageCell else {
                return
            }
            cell.modifyCapacityLabel(for: imageList.count - 1)
        }
    }

    lazy var imageCollectionView: UICollectionView = {
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
        textField.delegate = self
        return textField
    }()

    private let priceStackView = UIStackView()

    lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.borderStyle = .roundedRect
        textField.font = .preferredFont(forTextStyle: .subheadline)
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.delegate = self
        textField.keyboardType = .decimalPad
        return textField
    }()

    private lazy var currencySegmentedControl: UISegmentedControl = {
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
        textField.delegate = self
        return textField
    }()

    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .systemGray
        textView.text = "상품설명을 작성해 주세요.(최대 1000글자)"
        textView.font = .preferredFont(forTextStyle: .footnote)
        textView.delegate = self
        return textView
    }()

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
                if indexPath.item == 0 {
                    cell.configureFirstCell()
                }
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

        var snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
        snapshot.appendSections([.image])
        imageList.append(UIImage())
        snapshot.appendItems(imageList, toSection: .image)
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

// MARK: Text View Delegate
extension ProductRegisterView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .systemGray
            textView.text = "상품설명을 작성해 주세요. (최대 1000글자)"
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray {
            textView.textColor = .black
            textView.text = ""
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.textStorage.length + text.count > 1000 {
            return false
        }
        return true
    }
}
