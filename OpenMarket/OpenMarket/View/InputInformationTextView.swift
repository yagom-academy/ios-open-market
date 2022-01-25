//
//  PlaceholderTextView.swift
//  OpenMarket
//
//  Created by yeha on 2022/01/20.
//

import UIKit

class InputInformationTextView: UITextView {

    private let type: TextViewType
    private var placeholderText: String?

    init(type: TextViewType) {
        self.type = type
        super.init(frame: .zero, textContainer: .none)
        setupPlaceholderText(type: type)
        setupTextView(type: type)
        delegate = self
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupPlaceholderText(type: TextViewType) {
        placeholderText = getPlaceholderText(by: type)
        text = text.isEmpty ? placeholderText : text
    }


    private func setupTextView(type: TextViewType) {
        font = .preferredFont(forTextStyle: .body)
        textColor = text == placeholderText ? Color.placeholderText : Color.text
        isScrollEnabled = false
        autocorrectionType = .no
        accessibilityIdentifier = type.rawValue

        if type != .description {
            layer.borderColor = Color.placeholderText.cgColor
            layer.backgroundColor = Color.background.cgColor
            layer.borderWidth = 1
            layer.cornerRadius = 8
        }
    }
}

extension InputInformationTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        text = text == placeholderText ? "" : text
        textColor = text == placeholderText ? Color.placeholderText : Color.text
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if text.isEmpty {
            text = getPlaceholderText(by: type)
            textColor = Color.placeholderText
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if !text.isEmpty {

        }
    }
}

extension InputInformationTextView {
    enum Color {
        static let text = UIColor.black
        static let placeholderText = UIColor.systemGray3
        static let background = UIColor.white
    }

    enum TextViewType: String {
        case name
        case price
        case bargainPrice
        case stock
        case description
    }

    enum PlaceholderText {
        static let name = "상품명"
        static let price = "상품가격"
        static let bargainPrice = "할인금액"
        static let stock = "재고수량"
        static let description = "설명을 입력해주세요"
    }

    private func getPlaceholderText(by type: TextViewType) -> String {
        switch type {
        case .name:
            return PlaceholderText.name
        case .price:
            return PlaceholderText.price
        case .bargainPrice:
            return PlaceholderText.bargainPrice
        case .stock:
            return PlaceholderText.stock
        case .description:
            return PlaceholderText.description
        }
    }
}
