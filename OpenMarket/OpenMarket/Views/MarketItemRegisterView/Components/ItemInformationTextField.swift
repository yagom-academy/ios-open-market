import UIKit

class ItemInformationTextField: UITextField {
    enum TextFieldType: String {
        case name
        case price
        case discountedPrice
        case stock
    }
    enum PlaceholderText {
        static let name = "상품명"
        static let price = "상품가격"
        static let discountedPrice = "할인금액"
        static let stock = "재고수량"
    }
    enum Color {
        static let text = UIColor.black
        static let placeholderText = UIColor.systemGray3
        static let background = UIColor.white
    }

    private let type: TextFieldType

    init(type: TextFieldType) {
        self.type = type
        super.init(frame: .zero)
        placeholder = setupPlaceholderText(by: type)
        setupTextField(type: type)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupPlaceholderText(by type: TextFieldType) -> String {
        switch type {
        case .name:
            return PlaceholderText.name
        case .price:
            return PlaceholderText.price
        case .discountedPrice:
            return PlaceholderText.discountedPrice
        case .stock:
            return PlaceholderText.stock
        }
    }

    private func setupTextField(type: TextFieldType) {
        font = .preferredFont(forTextStyle: .body)
        autocorrectionType = .no
        layer.borderColor = UIColor.systemGray3.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 7
    }
}
