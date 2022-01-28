//
//  MarketCell.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/18.
//

import UIKit

final class MarketCell: UICollectionViewCell {
    // MARK: - Nested Type
    
    enum CellType {
        case list
        case grid
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    //MARK: - Properties
    
    private var cellType: CellType?
    
    //MARK: - Configure Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        discountedPriceLabel.isHidden = false
        priceLabel.attributedText = nil
    }
    
    func configure(with product: Product, cellType: CellType) {
        self.cellType = cellType
        setBorder()
        setImageView(with: product.thumbnailURL)
        setupLabels(with: product)
    }
}

// MARK: - Private Methods

extension MarketCell {
    private func setBorder() {
        if cellType == .grid {
            layer.borderWidth = 1
            layer.borderColor = UIColor.lightGray.cgColor
            layer.cornerRadius = 10
        }
    }
    
    private func setupLabels(with product: Product) {
        let presentation = getPresentation(product: product, identifier: MarketCell.identifier)
        
        setProductNameLabel(with: presentation)
        setStockLabel(with: presentation)
        setPriceLabel(with: presentation)
        setDiscountedPriceLabel(with: presentation)
    }

    private func setImageView(with urlString: String) {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url) else {
            return
        }
        imageView.image = UIImage(data: data)
    }
    
    private func setProductNameLabel(with presentation: ProductUIPresentation) {
        productNameLabel.text = presentation.productNameLabelText
        productNameLabel.font = presentation.productNameLabelFont
    }
    
    private func setStockLabel(with presentation: ProductUIPresentation) {
        stockLabel.text = presentation.stockLabelText
        stockLabel.textColor = presentation.stockLabelTextColor
    }
    
    private func setPriceLabel(with presentation: ProductUIPresentation) {
        priceLabel.text = presentation.priceLabelText
        priceLabel.textColor = presentation.priceLabelTextColor
        if presentation.priceLabelIsCrossed {
            priceLabel.attributedText = priceLabel.convertToAttributedString(from: priceLabel)
        }
//        priceLabel.attributedText = presentation.priceLabelIsCrossed ? priceLabel.convertToAttributedString(from: priceLabel) : nil
    }
    
    private func setDiscountedPriceLabel(with presentation: ProductUIPresentation) {
        discountedPriceLabel.text = presentation.discountedLabelText
        discountedPriceLabel.textColor = presentation.discountedLabelTextColor
        discountedPriceLabel.isHidden = presentation.discountedLabelIsHidden
    }
}

// MARK: - ProductUIPresentable

extension MarketCell: ProductUIPresentable {}

// MARK: - IdentifiableView

extension MarketCell: IdentifiableView {}
