//
//  StockLabel.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/22.
//

import UIKit

final class StockLabel: UILabel {
    @PositiveNumber var stock: Int {
        didSet {
            setText(for: stock)
            setTextColor(for: stock)
        }
    }

    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        font = UIFont.preferredFont(forTextStyle: .caption1)
        adjustsFontForContentSizeCategory = true
        textAlignment = .right
        textColor = .orange
        numberOfLines = 0
        text = "품절"
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setText(for stock: Int) {
        let stockInformation: String
        
        if stock == 0 {
            stockInformation = "품절"
        } else {
            stockInformation = "잔여수량 : \(stock)"
        }
        text = stockInformation
        
    }
    
    private func setTextColor(for stock: Int) {
        if stock == 0 {
            textColor = .orange
        } else {
            textColor = .gray
        }
    }
}
