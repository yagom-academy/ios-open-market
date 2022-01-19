import Foundation
import UIKit

class ProductRegisterView: UIStackView {

    private lazy var imageCollectionView = UICollectionView()
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.borderStyle = .roundedRect
        return textField
    }()
    private let priceStackView = UIStackView()
    private lazy var priceTextField = UITextField()
    private lazy var currencySegmentedControl = UISegmentedControl()
    private lazy var discountTextField = UITextField()
    private lazy var stockTextField = UITextField()
    private lazy var descriptionTextView = UITextView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder: NSCoder) {
        fatalError()
    }
}

extension ProductRegisterView {
    func configureStackVeiw() {
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fill
    }

    func configureHierarchy() {
        self.addArrangedSubview(imageCollectionView)
        self.addSubview(nameTextField)
        self.addSubview(priceStackView)
        configurePriceStackView()
        self.addSubview(discountTextField)
        self.addSubview(stockTextField)
        self.addSubview(descriptionTextView)
    }

    func configurePriceStackView() {
        priceStackView.axis = .horizontal
        priceStackView.alignment = .fill
        priceStackView.distribution = .fillProportionally
        priceStackView.spacing = 4
        priceStackView.addArrangedSubview(priceTextField)
        priceStackView.addArrangedSubview(currencySegmentedControl)
    }
}
