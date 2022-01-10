//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/07.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet var backgroundStackView: UIStackView!
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var priceStackView: UIStackView!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var productDiscountPrice: UILabel!
    @IBOutlet var productStockPrice: UILabel!

    static let listIdentifier = "ListView"
    static let gridItentifier = "GridView"
    static let listNibName = "ListCollectionViewCell"
    static let gridNibName = "GridCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func styleConfigure(identifier: String) {
        if identifier == Self.listIdentifier {
            setupListView()
        } else {
            setupGridView()
        }
    }
    
    private func setupGridView() {
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.borderWidth = 1
    }

    private func setupListView() {
        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
    }
    
}
