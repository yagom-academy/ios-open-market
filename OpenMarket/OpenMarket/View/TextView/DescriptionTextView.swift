//
//  DescriptionTextView.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/29.
//

import UIKit

final class DescriptionTextView: UITextView {
    private var minimumLength: Int
    private var maximumLength: Int
    
    init(minimumLength: Int = 0, maximumLength: Int = 1000) {
        self.minimumLength = minimumLength
        self.maximumLength = maximumLength
        super.init(frame: .zero, textContainer: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .white
        font = .preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = true
        keyboardType = .default
    }
    
    func isLessThanOrEqualMaximumLength(_ length: Int) -> Bool {
        if length <= maximumLength {
            return true
        } else {
            return false
        }
    }
}
